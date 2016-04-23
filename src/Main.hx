import luxe.Input;
import luxe.States;
import luxe.Vector;

import mint.Canvas;
import mint.render.luxe.LuxeMintRender;
import mint.layout.margins.Margins;

typedef GlobalData = {
    states: States,
    ui: phoenix.Batcher,
    canvas: Canvas,
    layout: Margins
}

class Main extends luxe.Game
{
    var global : GlobalData = { states: null, ui: null, canvas: null, layout: null };

    override function config(config:luxe.AppConfig) : luxe.AppConfig
    {
        config.preload.jsons.push({id: 'assets/parcel.json'});
        config.render.depth = 24;

        return config;
    }

    function setup()
    {
        global.ui = Luxe.renderer.create_batcher({
            name: 'ui',
            layer: 1
        });

        Luxe.input.bind_key("y+", Key.key_q);
        Luxe.input.bind_key("y-", Key.key_e);
        Luxe.input.bind_key("x-", Key.key_a);
        Luxe.input.bind_key("x+", Key.key_d);
        Luxe.input.bind_key("z+", Key.key_w);
        Luxe.input.bind_key("z-", Key.key_s);

        Luxe.input.bind_key("fov+", Key.key_z);
        Luxe.input.bind_key("fov-", Key.key_x);

        Luxe.input.bind_key("yr+", Key.left);
        Luxe.input.bind_key("yr-", Key.right);
        Luxe.input.bind_key("xr+", Key.up);
        Luxe.input.bind_key("xr-", Key.down);

        Luxe.input.bind_key("toggle", Key.key_t);

        // Set up batchers, states etc.
        global.states = new States({ name: 'states' });
        global.states.add(new MainState(global, Luxe.renderer.batcher));
        global.states.set('MainState');

        trace(Luxe.screen.size);
    }

    function setup_canvas()
    {
        var renderer = new LuxeMintRender({
            batcher: global.ui
        });

        var canvas = new util.AutoCanvas({
            name: 'Canvas',
            rendering: renderer,
            x: 0, y: 0, w: Luxe.screen.w, h: Luxe.screen.h
        });

        canvas.auto_listen();

        new mint.focus.Focus(canvas);

        global.canvas = canvas;

        global.layout = new Margins();
    }

    function load_complete(_)
    {
        setup();
        setup_canvas();
    }

    override function ready()
    {
        var preload = new luxe.Parcel();
        preload.from_json(Luxe.resources.json('assets/parcel.json').asset.json);

        new luxe.ParcelProgress({
          parcel: preload,
          oncomplete: load_complete
        });

        preload.load();
    } //ready

    override function onkeyup( e:KeyEvent )
    {
        if (e.keycode == Key.escape)
        {
            Luxe.shutdown();
        }
    } //onkeyup

    override function update(dt:Float)
    {
    } //update

} //Main
