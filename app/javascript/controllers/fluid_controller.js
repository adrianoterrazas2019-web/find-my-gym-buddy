import { Controller } from "@hotwired/stimulus"
import * as THREE from "three"

export default class extends Controller {
  connect() {
    const container = this.element

    // ── Config ──────────────────────────────────────────────────────
    function cssVar(name) {
      return getComputedStyle(document.documentElement).getPropertyValue(name).trim()
    }
    function themeColors() {
      return [cssVar('--gym-primary') || '#F97316', cssVar('--gym-secondary') || '#FB923C', '#ffffff']
    }
    const MOUSE_FORCE    = 20
    const CURSOR_SIZE    = 100
    const IS_VISCOUS     = false
    const VISCOUS        = 30
    const ITER_VISCOUS   = 32
    const ITER_POISSON   = 32
    const DT             = 0.014
    const USE_BFECC      = true
    const RESOLUTION     = 0.5
    const IS_BOUNCE      = false
    const AUTO_DEMO      = true
    const AUTO_SPEED     = 0.5
    const AUTO_INTENSITY = 2.2
    const TAKEOVER_DUR   = 0.25
    const RESUME_DELAY   = 1000
    const RAMP_DUR       = 0.6

    // ── Palette texture ─────────────────────────────────────────────
    function makePaletteTexture(stops) {
      const arr = stops.length === 1 ? [stops[0], stops[0]] : stops
      const data = new Uint8Array(arr.length * 4)
      arr.forEach((hex, i) => {
        const c = new THREE.Color(hex)
        data[i * 4]     = Math.round(c.r * 255)
        data[i * 4 + 1] = Math.round(c.g * 255)
        data[i * 4 + 2] = Math.round(c.b * 255)
        data[i * 4 + 3] = 255
      })
      const tex = new THREE.DataTexture(data, arr.length, 1, THREE.RGBAFormat)
      tex.magFilter = tex.minFilter = THREE.LinearFilter
      tex.wrapS = tex.wrapT = THREE.ClampToEdgeWrapping
      tex.generateMipmaps = false
      tex.needsUpdate = true
      return tex
    }

    let paletteTex = makePaletteTexture(themeColors())
    const bgVec4   = new THREE.Vector4(0, 0, 0, 0)

    // ── Common ──────────────────────────────────────────────────────
    const Common = {
      width: 1, height: 1, time: 0, delta: 0,
      renderer: null, clock: null, container: null,

      init(el) {
        this.container = el
        const r = el.getBoundingClientRect()
        this.width  = Math.max(1, Math.floor(r.width))
        this.height = Math.max(1, Math.floor(r.height))
        this.renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true })
        this.renderer.autoClear = false
        this.renderer.setClearColor(0x000000, 0)
        this.renderer.setPixelRatio(Math.min(window.devicePixelRatio || 1, 2))
        this.renderer.setSize(this.width, this.height)
        this.clock = new THREE.Clock()
        this.clock.start()
      },

      resize() {
        if (!this.container) return
        const r = this.container.getBoundingClientRect()
        this.width  = Math.max(1, Math.floor(r.width))
        this.height = Math.max(1, Math.floor(r.height))
        if (this.renderer) this.renderer.setSize(this.width, this.height, false)
      },

      update() {
        this.delta = this.clock.getDelta()
        this.time += this.delta
      }
    }

    // ── Mouse ───────────────────────────────────────────────────────
    const Mouse = {
      coords:            new THREE.Vector2(),
      coords_old:        new THREE.Vector2(),
      diff:              new THREE.Vector2(),
      mouseMoved:        false,
      isHoverInside:     false,
      hasUserControl:    false,
      isAutoActive:      false,
      takeoverActive:    false,
      takeoverStartTime: 0,
      takeoverDuration:  TAKEOVER_DUR,
      takeoverFrom:      new THREE.Vector2(),
      takeoverTo:        new THREE.Vector2(),
      autoIntensity:     AUTO_INTENSITY,
      onInteract:        null,
      _timer:            null,
      _el:               null,
      _win:              null,
      _h:                {},

      init(el) {
        this._el  = el
        this._win = el.ownerDocument?.defaultView || window
        this._h.move   = e => this._onMove(e)
        this._h.tstart = e => this._onTStart(e)
        this._h.tmove  = e => this._onTMove(e)
        this._h.tend   = () => { this.isHoverInside = false }
        this._h.leave  = () => { this.isHoverInside = false }
        this._win.addEventListener('mousemove',  this._h.move)
        this._win.addEventListener('touchstart', this._h.tstart, { passive: true })
        this._win.addEventListener('touchmove',  this._h.tmove,  { passive: true })
        this._win.addEventListener('touchend',   this._h.tend)
        el.ownerDocument?.addEventListener('mouseleave', this._h.leave)
      },

      dispose() {
        if (!this._win) return
        this._win.removeEventListener('mousemove',  this._h.move)
        this._win.removeEventListener('touchstart', this._h.tstart)
        this._win.removeEventListener('touchmove',  this._h.tmove)
        this._win.removeEventListener('touchend',   this._h.tend)
        this._el?.ownerDocument?.removeEventListener('mouseleave', this._h.leave)
      },

      _inside(cx, cy) {
        if (!this._el) return false
        const r = this._el.getBoundingClientRect()
        return cx >= r.left && cx <= r.right && cy >= r.top && cy <= r.bottom
      },

      _setCoords(x, y) {
        if (this._timer) clearTimeout(this._timer)
        const r = this._el.getBoundingClientRect()
        if (!r.width || !r.height) return
        this.coords.set((x - r.left) / r.width * 2 - 1, -((y - r.top) / r.height * 2 - 1))
        this.mouseMoved = true
        this._timer = setTimeout(() => { this.mouseMoved = false }, 100)
      },

      setNormalized(nx, ny) {
        this.coords.set(nx, ny)
        this.mouseMoved = true
      },

      _onMove(e) {
        this.isHoverInside = this._inside(e.clientX, e.clientY)
        if (!this.isHoverInside) return
        if (this.onInteract) this.onInteract()
        if (this.isAutoActive && !this.hasUserControl && !this.takeoverActive) {
          const r = this._el.getBoundingClientRect()
          if (!r.width || !r.height) return
          this.takeoverFrom.copy(this.coords)
          this.takeoverTo.set((e.clientX - r.left) / r.width * 2 - 1, -((e.clientY - r.top) / r.height * 2 - 1))
          this.takeoverStartTime = performance.now()
          this.takeoverActive = true
          this.hasUserControl = true
          this.isAutoActive   = false
          return
        }
        this._setCoords(e.clientX, e.clientY)
        this.hasUserControl = true
      },

      _onTStart(e) {
        if (e.touches.length !== 1) return
        const t = e.touches[0]
        this.isHoverInside = this._inside(t.clientX, t.clientY)
        if (!this.isHoverInside) return
        if (this.onInteract) this.onInteract()
        this._setCoords(t.clientX, t.clientY)
        this.hasUserControl = true
      },

      _onTMove(e) {
        if (e.touches.length !== 1) return
        const t = e.touches[0]
        this.isHoverInside = this._inside(t.clientX, t.clientY)
        if (!this.isHoverInside) return
        if (this.onInteract) this.onInteract()
        this._setCoords(t.clientX, t.clientY)
      },

      update() {
        if (this.takeoverActive) {
          const t = (performance.now() - this.takeoverStartTime) / (this.takeoverDuration * 1000)
          if (t >= 1) {
            this.takeoverActive = false
            this.coords.copy(this.takeoverTo)
            this.coords_old.copy(this.coords)
            this.diff.set(0, 0)
          } else {
            this.coords.copy(this.takeoverFrom).lerp(this.takeoverTo, t * t * (3 - 2 * t))
          }
        }
        this.diff.subVectors(this.coords, this.coords_old)
        this.coords_old.copy(this.coords)
        if (!this.coords_old.x && !this.coords_old.y) this.diff.set(0, 0)
        if (this.isAutoActive && !this.takeoverActive) this.diff.multiplyScalar(this.autoIntensity)
      }
    }

    // ── AutoDriver ──────────────────────────────────────────────────
    class AutoDriver {
      constructor(manager, opts) {
        this.manager         = manager
        this.enabled         = opts.enabled
        this.speed           = opts.speed
        this.resumeDelay     = opts.resumeDelay || 3000
        this.rampDurationMs  = (opts.rampDuration || 0) * 1000
        this.active          = false
        this.current         = new THREE.Vector2()
        this.target          = new THREE.Vector2()
        this.lastTime        = performance.now()
        this.activationTime  = 0
        this.margin          = 0.2
        this._dir            = new THREE.Vector2()
        this._pick()
      }
      _pick() {
        const m = 1 - this.margin
        this.target.set(Math.random() * 2 * m - m, Math.random() * 2 * m - m)
      }
      forceStop() { this.active = false; Mouse.isAutoActive = false }
      update() {
        if (!this.enabled) return
        const now  = performance.now()
        const idle = now - this.manager.lastUserInteraction
        if (idle < this.resumeDelay || Mouse.isHoverInside) {
          if (this.active) this.forceStop()
          return
        }
        if (!this.active) {
          this.active = true
          this.current.copy(Mouse.coords)
          this.lastTime = now
          this.activationTime = now
        }
        Mouse.isAutoActive = true
        const dtSec = Math.min((now - this.lastTime) / 1000, 0.016)
        this.lastTime = now
        this._dir.subVectors(this.target, this.current)
        const dist = this._dir.length()
        if (dist < 0.01) { this._pick(); return }
        this._dir.normalize()
        let ramp = 1
        if (this.rampDurationMs > 0) {
          const t = Math.min(1, (now - this.activationTime) / this.rampDurationMs)
          ramp = t * t * (3 - 2 * t)
        }
        this.current.addScaledVector(this._dir, Math.min(this.speed * dtSec * ramp, dist))
        Mouse.setNormalized(this.current.x, this.current.y)
      }
    }

    // ── GLSL Shaders ────────────────────────────────────────────────
    const face_vert = `
      attribute vec3 position;
      uniform vec2 px;
      uniform vec2 boundarySpace;
      varying vec2 uv;
      precision highp float;
      void main(){
        vec3 pos = position;
        vec2 scale = 1.0 - boundarySpace * 2.0;
        pos.xy = pos.xy * scale;
        uv = vec2(0.5) + pos.xy * 0.5;
        gl_Position = vec4(pos, 1.0);
      }
    `
    const line_vert = `
      attribute vec3 position;
      uniform vec2 px;
      precision highp float;
      varying vec2 uv;
      void main(){
        vec3 pos = position;
        uv = 0.5 + pos.xy * 0.5;
        vec2 n = sign(pos.xy);
        pos.xy = abs(pos.xy) - px * 1.0;
        pos.xy *= n;
        gl_Position = vec4(pos, 1.0);
      }
    `
    const mouse_vert = `
      precision highp float;
      attribute vec3 position;
      attribute vec2 uv;
      uniform vec2 center;
      uniform vec2 scale;
      uniform vec2 px;
      varying vec2 vUv;
      void main(){
        vec2 pos = position.xy * scale * 2.0 * px + center;
        vUv = uv;
        gl_Position = vec4(pos, 0.0, 1.0);
      }
    `
    const advection_frag = `
      precision highp float;
      uniform sampler2D velocity;
      uniform float dt;
      uniform bool isBFECC;
      uniform vec2 fboSize;
      uniform vec2 px;
      varying vec2 uv;
      void main(){
        vec2 ratio = max(fboSize.x, fboSize.y) / fboSize;
        if(isBFECC == false){
          vec2 vel = texture2D(velocity, uv).xy;
          vec2 uv2 = uv - vel * dt * ratio;
          gl_FragColor = vec4(texture2D(velocity, uv2).xy, 0.0, 0.0);
        } else {
          vec2 vel_old  = texture2D(velocity, uv).xy;
          vec2 spot_old = uv - vel_old * dt * ratio;
          vec2 vel_new1 = texture2D(velocity, spot_old).xy;
          vec2 spot_new2 = spot_old + vel_new1 * dt * ratio;
          vec2 spot_new3 = uv - (spot_new2 - uv) / 2.0;
          vec2 vel_2     = texture2D(velocity, spot_new3).xy;
          vec2 spot_old2 = spot_new3 - vel_2 * dt * ratio;
          gl_FragColor = vec4(texture2D(velocity, spot_old2).xy, 0.0, 0.0);
        }
      }
    `
    const color_frag = `
      precision highp float;
      uniform sampler2D velocity;
      uniform sampler2D palette;
      uniform vec4 bgColor;
      varying vec2 uv;
      void main(){
        vec2  vel  = texture2D(velocity, uv).xy;
        float lenv = clamp(length(vel), 0.0, 1.0);
        vec3  c    = texture2D(palette, vec2(lenv, 0.5)).rgb;
        gl_FragColor = vec4(mix(bgColor.rgb, c, lenv), mix(bgColor.a, 1.0, lenv));
      }
    `
    const divergence_frag = `
      precision highp float;
      uniform sampler2D velocity;
      uniform float dt;
      uniform vec2 px;
      varying vec2 uv;
      void main(){
        float x0 = texture2D(velocity, uv - vec2(px.x, 0.0)).x;
        float x1 = texture2D(velocity, uv + vec2(px.x, 0.0)).x;
        float y0 = texture2D(velocity, uv - vec2(0.0, px.y)).y;
        float y1 = texture2D(velocity, uv + vec2(0.0, px.y)).y;
        gl_FragColor = vec4((x1 - x0 + y1 - y0) / 2.0 / dt);
      }
    `
    const externalForce_frag = `
      precision highp float;
      uniform vec2 force;
      uniform vec2 center;
      uniform vec2 scale;
      uniform vec2 px;
      varying vec2 vUv;
      void main(){
        vec2  circle = (vUv - 0.5) * 2.0;
        float d = 1.0 - min(length(circle), 1.0);
        d *= d;
        gl_FragColor = vec4(force * d, 0.0, 1.0);
      }
    `
    const poisson_frag = `
      precision highp float;
      uniform sampler2D pressure;
      uniform sampler2D divergence;
      uniform vec2 px;
      varying vec2 uv;
      void main(){
        float p0  = texture2D(pressure, uv + vec2(px.x * 2.0, 0.0)).r;
        float p1  = texture2D(pressure, uv - vec2(px.x * 2.0, 0.0)).r;
        float p2  = texture2D(pressure, uv + vec2(0.0, px.y * 2.0)).r;
        float p3  = texture2D(pressure, uv - vec2(0.0, px.y * 2.0)).r;
        float div = texture2D(divergence, uv).r;
        gl_FragColor = vec4((p0 + p1 + p2 + p3) / 4.0 - div);
      }
    `
    const pressure_frag = `
      precision highp float;
      uniform sampler2D pressure;
      uniform sampler2D velocity;
      uniform vec2 px;
      uniform float dt;
      varying vec2 uv;
      void main(){
        float p0 = texture2D(pressure, uv + vec2(px.x, 0.0)).r;
        float p1 = texture2D(pressure, uv - vec2(px.x, 0.0)).r;
        float p2 = texture2D(pressure, uv + vec2(0.0, px.y)).r;
        float p3 = texture2D(pressure, uv - vec2(0.0, px.y)).r;
        vec2  v  = texture2D(velocity, uv).xy;
        gl_FragColor = vec4(v - vec2(p0 - p1, p2 - p3) * 0.5 * dt, 0.0, 1.0);
      }
    `
    const viscous_frag = `
      precision highp float;
      uniform sampler2D velocity;
      uniform sampler2D velocity_new;
      uniform float v;
      uniform vec2 px;
      uniform float dt;
      varying vec2 uv;
      void main(){
        vec2 old  = texture2D(velocity,     uv).xy;
        vec2 new0 = texture2D(velocity_new, uv + vec2(px.x * 2.0, 0.0)).xy;
        vec2 new1 = texture2D(velocity_new, uv - vec2(px.x * 2.0, 0.0)).xy;
        vec2 new2 = texture2D(velocity_new, uv + vec2(0.0, px.y * 2.0)).xy;
        vec2 new3 = texture2D(velocity_new, uv - vec2(0.0, px.y * 2.0)).xy;
        gl_FragColor = vec4((4.0 * old + v * dt * (new0 + new1 + new2 + new3)) / (4.0 * (1.0 + v * dt)), 0.0, 0.0);
      }
    `

    // ── ShaderPass base ─────────────────────────────────────────────
    class ShaderPass {
      constructor(props) {
        this.props    = props || {}
        this.uniforms = this.props.material?.uniforms
        this.scene = null; this.camera = null
        this.material = null; this.geometry = null; this.plane = null
      }
      init() {
        this.scene  = new THREE.Scene()
        this.camera = new THREE.Camera()
        if (this.uniforms) {
          this.material = new THREE.RawShaderMaterial(this.props.material)
          this.geometry = new THREE.PlaneGeometry(2, 2)
          this.plane    = new THREE.Mesh(this.geometry, this.material)
          this.scene.add(this.plane)
        }
      }
      update() {
        Common.renderer.setRenderTarget(this.props.output || null)
        Common.renderer.render(this.scene, this.camera)
        Common.renderer.setRenderTarget(null)
      }
    }

    // ── Advection ───────────────────────────────────────────────────
    class Advection extends ShaderPass {
      constructor(sp) {
        super({
          material: {
            vertexShader: face_vert, fragmentShader: advection_frag,
            uniforms: {
              boundarySpace: { value: sp.cellScale },
              px:            { value: sp.cellScale },
              fboSize:       { value: sp.fboSize },
              velocity:      { value: sp.src.texture },
              dt:            { value: sp.dt },
              isBFECC:       { value: true }
            }
          },
          output: sp.dst
        })
        this.uniforms = this.props.material.uniforms
        this.init()
        const g = new THREE.BufferGeometry()
        g.setAttribute('position', new THREE.BufferAttribute(new Float32Array([
          -1,-1,0, -1,1,0, -1,1,0, 1,1,0, 1,1,0, 1,-1,0, 1,-1,0, -1,-1,0
        ]), 3))
        this.line = new THREE.LineSegments(g, new THREE.RawShaderMaterial({
          vertexShader: line_vert, fragmentShader: advection_frag, uniforms: this.uniforms
        }))
        this.scene.add(this.line)
      }
      update({ dt, isBounce, BFECC }) {
        this.uniforms.dt.value      = dt
        this.uniforms.isBFECC.value = BFECC
        this.line.visible           = isBounce
        super.update()
      }
    }

    // ── ExternalForce ───────────────────────────────────────────────
    class ExternalForce extends ShaderPass {
      constructor(sp) {
        super({ output: sp.dst })
        super.init()
        this.mouse = new THREE.Mesh(
          new THREE.PlaneGeometry(1, 1),
          new THREE.RawShaderMaterial({
            vertexShader: mouse_vert, fragmentShader: externalForce_frag,
            blending: THREE.AdditiveBlending, depthWrite: false,
            uniforms: {
              px:     { value: sp.cellScale },
              force:  { value: new THREE.Vector2() },
              center: { value: new THREE.Vector2() },
              scale:  { value: new THREE.Vector2(sp.cursor_size, sp.cursor_size) }
            }
          })
        )
        this.scene.add(this.mouse)
      }
      update(props) {
        const u  = this.mouse.material.uniforms
        const sx = props.cursor_size * props.cellScale.x
        const sy = props.cursor_size * props.cellScale.y
        u.force.value.set((Mouse.diff.x / 2) * props.mouse_force, (Mouse.diff.y / 2) * props.mouse_force)
        u.center.value.set(
          Math.min(Math.max(Mouse.coords.x, -1 + sx + props.cellScale.x * 2), 1 - sx - props.cellScale.x * 2),
          Math.min(Math.max(Mouse.coords.y, -1 + sy + props.cellScale.y * 2), 1 - sy - props.cellScale.y * 2)
        )
        u.scale.value.set(props.cursor_size, props.cursor_size)
        super.update()
      }
    }

    // ── Viscous ─────────────────────────────────────────────────────
    class Viscous extends ShaderPass {
      constructor(sp) {
        super({
          material: {
            vertexShader: face_vert, fragmentShader: viscous_frag,
            uniforms: {
              boundarySpace: { value: sp.boundarySpace },
              velocity:      { value: sp.src.texture },
              velocity_new:  { value: sp.dst_.texture },
              v:             { value: sp.viscous },
              px:            { value: sp.cellScale },
              dt:            { value: sp.dt }
            }
          },
          output: sp.dst, output0: sp.dst_, output1: sp.dst
        })
        this.init()
      }
      update({ viscous, iterations, dt }) {
        this.uniforms.v.value  = viscous
        this.uniforms.dt.value = dt
        let fbo_in, fbo_out
        for (let i = 0; i < iterations; i++) {
          fbo_in  = i % 2 === 0 ? this.props.output0 : this.props.output1
          fbo_out = i % 2 === 0 ? this.props.output1 : this.props.output0
          this.uniforms.velocity_new.value = fbo_in.texture
          this.props.output = fbo_out
          super.update()
        }
        return fbo_out
      }
    }

    // ── Divergence ──────────────────────────────────────────────────
    class Divergence extends ShaderPass {
      constructor(sp) {
        super({
          material: {
            vertexShader: face_vert, fragmentShader: divergence_frag,
            uniforms: {
              boundarySpace: { value: sp.boundarySpace },
              velocity:      { value: sp.src.texture },
              px:            { value: sp.cellScale },
              dt:            { value: sp.dt }
            }
          },
          output: sp.dst
        })
        this.init()
      }
      update({ vel }) { this.uniforms.velocity.value = vel.texture; super.update() }
    }

    // ── Poisson ─────────────────────────────────────────────────────
    class Poisson extends ShaderPass {
      constructor(sp) {
        super({
          material: {
            vertexShader: face_vert, fragmentShader: poisson_frag,
            uniforms: {
              boundarySpace: { value: sp.boundarySpace },
              pressure:      { value: sp.dst_.texture },
              divergence:    { value: sp.src.texture },
              px:            { value: sp.cellScale }
            }
          },
          output: sp.dst, output0: sp.dst_, output1: sp.dst
        })
        this.init()
      }
      update({ iterations }) {
        let p_in, p_out
        for (let i = 0; i < iterations; i++) {
          p_in  = i % 2 === 0 ? this.props.output0 : this.props.output1
          p_out = i % 2 === 0 ? this.props.output1 : this.props.output0
          this.uniforms.pressure.value = p_in.texture
          this.props.output = p_out
          super.update()
        }
        return p_out
      }
    }

    // ── Pressure ────────────────────────────────────────────────────
    class Pressure extends ShaderPass {
      constructor(sp) {
        super({
          material: {
            vertexShader: face_vert, fragmentShader: pressure_frag,
            uniforms: {
              boundarySpace: { value: sp.boundarySpace },
              pressure:      { value: sp.src_p.texture },
              velocity:      { value: sp.src_v.texture },
              px:            { value: sp.cellScale },
              dt:            { value: sp.dt }
            }
          },
          output: sp.dst
        })
        this.init()
      }
      update({ vel, pressure }) {
        this.uniforms.velocity.value = vel.texture
        this.uniforms.pressure.value = pressure.texture
        super.update()
      }
    }

    // ── Simulation ──────────────────────────────────────────────────
    class Simulation {
      constructor() {
        this.opts = {
          iterations_poisson: ITER_POISSON, iterations_viscous: ITER_VISCOUS,
          mouse_force: MOUSE_FORCE, resolution: RESOLUTION, cursor_size: CURSOR_SIZE,
          viscous: VISCOUS, isBounce: IS_BOUNCE, dt: DT, isViscous: IS_VISCOUS, BFECC: USE_BFECC
        }
        this.fbos = { vel_0:null, vel_1:null, vel_viscous0:null, vel_viscous1:null, div:null, pressure_0:null, pressure_1:null }
        this.fboSize       = new THREE.Vector2()
        this.cellScale     = new THREE.Vector2()
        this.boundarySpace = new THREE.Vector2()
        this.calcSize()
        this.createFBOs()
        this.createPasses()
      }
      _floatType() {
        return /iPad|iPhone|iPod/i.test(navigator.userAgent) ? THREE.HalfFloatType : THREE.FloatType
      }
      createFBOs() {
        const opts = {
          type: this._floatType(), depthBuffer: false, stencilBuffer: false,
          minFilter: THREE.LinearFilter, magFilter: THREE.LinearFilter,
          wrapS: THREE.ClampToEdgeWrapping, wrapT: THREE.ClampToEdgeWrapping
        }
        for (const k in this.fbos) this.fbos[k] = new THREE.WebGLRenderTarget(this.fboSize.x, this.fboSize.y, opts)
      }
      createPasses() {
        const { fbos: f, cellScale: cs, boundarySpace: bs, opts: o } = this
        this.advection     = new Advection({ cellScale:cs, fboSize:this.fboSize, dt:o.dt, src:f.vel_0, dst:f.vel_1 })
        this.externalForce = new ExternalForce({ cellScale:cs, cursor_size:o.cursor_size, dst:f.vel_1 })
        this.viscous       = new Viscous({ cellScale:cs, boundarySpace:bs, viscous:o.viscous, src:f.vel_1, dst:f.vel_viscous1, dst_:f.vel_viscous0, dt:o.dt })
        this.divergence    = new Divergence({ cellScale:cs, boundarySpace:bs, src:f.vel_viscous0, dst:f.div, dt:o.dt })
        this.poisson       = new Poisson({ cellScale:cs, boundarySpace:bs, src:f.div, dst:f.pressure_1, dst_:f.pressure_0 })
        this.pressure      = new Pressure({ cellScale:cs, boundarySpace:bs, src_p:f.pressure_0, src_v:f.vel_viscous0, dst:f.vel_0, dt:o.dt })
      }
      calcSize() {
        const w = Math.max(1, Math.round(this.opts.resolution * Common.width))
        const h = Math.max(1, Math.round(this.opts.resolution * Common.height))
        this.cellScale.set(1 / w, 1 / h)
        this.fboSize.set(w, h)
      }
      resize() {
        this.calcSize()
        for (const k in this.fbos) this.fbos[k].setSize(this.fboSize.x, this.fboSize.y)
      }
      update() {
        if (this.opts.isBounce) { this.boundarySpace.set(0, 0) }
        else                    { this.boundarySpace.copy(this.cellScale) }
        this.advection.update({ dt:this.opts.dt, isBounce:this.opts.isBounce, BFECC:this.opts.BFECC })
        this.externalForce.update({ cursor_size:this.opts.cursor_size, mouse_force:this.opts.mouse_force, cellScale:this.cellScale })
        let vel = this.fbos.vel_1
        if (this.opts.isViscous) vel = this.viscous.update({ viscous:this.opts.viscous, iterations:this.opts.iterations_viscous, dt:this.opts.dt })
        this.divergence.update({ vel })
        const pressure = this.poisson.update({ iterations: this.opts.iterations_poisson })
        this.pressure.update({ vel, pressure })
      }
    }

    // ── Output ──────────────────────────────────────────────────────
    class Output {
      constructor() {
        this.sim    = new Simulation()
        this.scene  = new THREE.Scene()
        this.camera = new THREE.Camera()
        this.mesh   = new THREE.Mesh(
          new THREE.PlaneGeometry(2, 2),
          new THREE.RawShaderMaterial({
            vertexShader: face_vert, fragmentShader: color_frag,
            transparent: true, depthWrite: false,
            uniforms: {
              velocity:      { value: this.sim.fbos.vel_0.texture },
              boundarySpace: { value: new THREE.Vector2() },
              palette:       { value: paletteTex },
              bgColor:       { value: bgVec4 }
            }
          })
        )
        this.scene.add(this.mesh)
      }
      resize() { this.sim.resize() }
      render() {
        Common.renderer.setRenderTarget(null)
        Common.renderer.render(this.scene, this.camera)
      }
      update() { this.sim.update(); this.render() }
    }

    // ── WebGLManager ────────────────────────────────────────────────
    class WebGLManager {
      constructor() {
        this.isVisible           = true
        this.lastUserInteraction = performance.now()
        this.running             = false
        this.raf                 = null

        Common.init(container)
        Mouse.init(container)
        Mouse.autoIntensity    = AUTO_INTENSITY
        Mouse.takeoverDuration = TAKEOVER_DUR
        Mouse.onInteract = () => {
          this.lastUserInteraction = performance.now()
          this.autoDriver?.forceStop()
        }

        this.autoDriver = new AutoDriver(this, {
          enabled: AUTO_DEMO, speed: AUTO_SPEED,
          resumeDelay: RESUME_DELAY, rampDuration: RAMP_DUR
        })

        const canvas = Common.renderer.domElement
        Object.assign(canvas.style, { position:'absolute', top:'0', left:'0', width:'100%', height:'100%', pointerEvents:'none' })
        container.prepend(canvas)

        this.output = new Output()
        this._loop  = this.loop.bind(this)

        this._onResize = () => { Common.resize(); this.output.resize() }
        this._onVis    = () => { document.hidden ? this.pause() : (this.isVisible && this.start()) }
        window.addEventListener('resize', this._onResize)
        document.addEventListener('visibilitychange', this._onVis)
      }
      loop() {
        if (!this.running) return
        Mouse.update()
        Common.update()
        this.autoDriver.update()
        this.output.update()
        this.raf = requestAnimationFrame(this._loop)
      }
      start() { if (this.running) return; this.running = true; this.loop() }
      pause() {
        this.running = false
        if (this.raf) { cancelAnimationFrame(this.raf); this.raf = null }
      }
      dispose() {
        try {
          this.pause()
          window.removeEventListener('resize', this._onResize)
          document.removeEventListener('visibilitychange', this._onVis)
          Mouse.dispose()
          const canvas = Common.renderer?.domElement
          canvas?.parentNode?.removeChild(canvas)
          Common.renderer?.dispose()
          Common.renderer?.forceContextLoss()
          Common.renderer = null
        } catch (_) { /* ignore */ }
      }
    }

    // ── Boot ────────────────────────────────────────────────────────
    const webgl = new WebGLManager()

    let resizeRaf = null
    const ro = new ResizeObserver(() => {
      if (resizeRaf) cancelAnimationFrame(resizeRaf)
      resizeRaf = requestAnimationFrame(() => { Common.resize(); webgl.output.resize() })
    })
    ro.observe(container)

    const io = new IntersectionObserver(entries => {
      const e = entries[0]
      webgl.isVisible = e.isIntersecting && e.intersectionRatio > 0
      webgl.isVisible && !document.hidden ? webgl.start() : webgl.pause()
    }, { threshold: [0, 0.01, 0.1] })
    io.observe(container)

    webgl.start()

    const updatePalette = () => {
      const old = paletteTex
      paletteTex = makePaletteTexture(themeColors())
      webgl.output.mesh.material.uniforms.palette.value = paletteTex
      old.dispose()
    }
    window.addEventListener('colorscheme:changed', updatePalette)

    this._cleanup = () => {
      window.removeEventListener('colorscheme:changed', updatePalette)
      if (resizeRaf) cancelAnimationFrame(resizeRaf)
      ro.disconnect()
      io.disconnect()
      webgl.dispose()
    }
  }

  disconnect() {
    if (this._cleanup) { this._cleanup(); this._cleanup = null }
  }
}
