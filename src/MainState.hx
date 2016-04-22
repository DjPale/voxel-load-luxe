import luxe.States;
import luxe.Mesh;
import luxe.Text;
import luxe.Vector;

import Main;

class MainState extends State
{
    var global : GlobalData;
    var batcher : phoenix.Batcher;
    var txt : Text;
    var ctrl_light : Bool = false;
    var light : Vector = new Vector(300, 300, 90);
    var shader : phoenix.Shader;
    var spec : Float = 15.0;

    public function new(_global:GlobalData, _batcher:phoenix.Batcher)
    {
        super({ name: 'MainState' });

        global = _global;
        batcher = _batcher;
    }

    override function onenter<T>(ignored:T)
    {
        trace('enter state ' + this.name);

        setup_camera();
        setup_mesh();
    }

    override function update(dt:Float)
    {
        check_input(dt);
    }

    function setup_camera()
    {
        txt = new Text({
            name: 'txt',
            pos: new Vector(10, 20),
            batcher: global.ui
        });

        Luxe.camera.view.set_perspective({
            far: 1000,
            near: 0.1,
            fov: 45,
            aspect: Luxe.screen.w / Luxe.screen.h
        });

        Luxe.camera.pos.set_xyz(280, 240, 45);
    }

    function setup_mesh()
    {
        shader = Luxe.resources.shader('lit');
        shader.set_vector3('lightpos', light);
        shader.set_float('specular', spec);
        shader.set_vector4('lightambient', new Vector(0.2, 0.2, 0.2, 1.0));

        var tex = Luxe.resources.texture('assets/lninja2-test.png');
        var mesh = new Mesh({
            name: 'mesh',
            texture: tex,
            batcher: batcher,
            file: 'assets/lninja2-test.obj'
        });

        mesh.geometry.shader = shader;
        mesh.transform.pos.set_xy(Luxe.screen.mid.x, Luxe.screen.mid.y);
    }

    function setup_ui()
    {
        new mint.Slider({
            x: 10, y: 10, w: 16, h: 16*4,
            min: 0, max: 100,
            parent: global.canvas
        });
    }

    var yr = 0.0;
    var xr = 0.0;

    function check_input(dt:Float)
    {
        if (Luxe.input.inputreleased("toggle"))
        {
            ctrl_light = !ctrl_light;
        }

        var x = Luxe.camera.pos.x;
        var y = Luxe.camera.pos.y;
        var z = Luxe.camera.pos.z;
        var fov = Luxe.camera.view.fov;

        if (ctrl_light)
        {
            x = light.x;
            y = light.y;
            z = light.z;
            fov = spec;
        }

        var sz = 50;

        if (Luxe.input.inputdown("x-"))
        {
            x -= sz * dt;
        }
        else if (Luxe.input.inputdown("x+"))
        {
            x += sz * dt;
        }

        if (Luxe.input.inputdown("y+"))
        {
            y += sz * dt;
        }
        else if (Luxe.input.inputdown("y-"))
        {
            y -= sz * dt;
        }

        if (Luxe.input.inputdown("z+"))
        {
            z += sz * dt;
        }
        else if (Luxe.input.inputdown("z-"))
        {
            z -= sz * dt;
        }

        if (Luxe.input.inputdown("fov+"))
        {
            fov += 5 * dt;
        }
        else if (Luxe.input.inputdown("fov-"))
        {
            fov -= 5 * dt;
        }

        if (Luxe.input.inputdown("yr+"))
        {
            yr += sz * dt;
        }
        else if (Luxe.input.inputdown("yr-"))
        {
            yr -= sz * dt;
        }

        if (Luxe.input.inputdown("xr+"))
        {
            xr += sz * dt;
        }
        else if (Luxe.input.inputdown("xr-"))
        {
            xr -= sz * dt;
        }

        if (ctrl_light)
        {
            light.set_xyz(x, y, z);
            spec = fov;
            shader.set_vector3('lightpos', light);
            shader.set_float('specular', spec);
        }
        else
        {
            Luxe.camera.pos.set_xyz(x, y, z);
            Luxe.camera.view.fov = fov;
        }

        Luxe.camera.rotation.setFromEuler(new Vector(xr, yr, 0).radians());

        txt.text = Math.round(x) + "," + Math.round(y) + "," + Math.round(z) + "|" + Math.round(fov) + "+" + Math.round(yr);
    }
}
