# -*- coding: utf-8 -*-

from libqtile.config import Key, Group, Screen, Drag, Click
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook

@hook.subscribe.screen_change
def restart_on_randr(qtile, ev):
    qtile.cmd_restart()

follow_mouse_focus = True

m = "mod4"
a = "mod1"
s = "shift"
c = "control"

red = "#de5b56"
blue = "#7cafc2"
yellow = "#f7ca88"
white = "#f8f8f8"
foreground = "#282828"

keys = [
    Key([m, s],  "r", lazy.restart()),
    Key([m, s],  "q", lazy.shutdown()),
    Key([m, s], "c", lazy.window.kill()),
    Key([m], "space", lazy.next_layout()),
    Key([m, s], "space", lazy.layout.reset()),
    Key([m],  "q", lazy.to_screen(0), lazy.group.toscreen(0)),
    Key([m],  "w", lazy.to_screen(1), lazy.group.toscreen(1)),
    Key([m],  "e", lazy.to_screen(2), lazy.group.toscreen(2)),

    # Bindings to control the layouts
    Key([m], "t", lazy.window.toggle_floating()),
    Key([m], "f", lazy.window.toggle_fullscreen()),
    # These are unique to stack layout
    Key([m], "h", lazy.layout.left()),
    Key([m], "l", lazy.layout.right()),
    Key([m], "j", lazy.layout.down()),
    Key([m], "k", lazy.layout.up()),
    Key([m, s], "h", lazy.layout.swap_left()),
    Key([m, s], "l", lazy.layout.swap_right()),
    Key([m, s], "j", lazy.layout.shuffle_down()),
    Key([m, s], "k", lazy.layout.shuffle_up()),
    Key([m], "i", lazy.layout.grow()),
    Key([m], "u", lazy.layout.shrink()),
    Key([m], "o", lazy.layout.maximize()),
    # Launching applications
    # Qtile application launcher
    Key([m], "r", lazy.spawncmd(prompt='shell>')),
    # Application Launcher
    Key([m], "p", lazy.spawn("dmenu_run")),
    # Terminal Application
    Key([m, s], "Return", lazy.spawn("urxvt")),
    # Emacs
    Key([m, s], "e", lazy.spawn("emacs")),
    # Browser
    Key([m, s], "w", lazy.spawn("brave")),

    # Change the volume and music if our keyboard has keys
    Key( [], "XF86AudioRaiseVolume", lazy.spawn("pulsemixer --change-volume +5")),
    Key( [], "XF86AudioLowerVolume", lazy.spawn("pulsemixer --change-volume -5")),
    Key( [], "XF86AudioMute", lazy.spawn("pulsemixer --toggle-mute")),
    Key( [], "XF86AudioPrev", lazy.spawn("mpc prev")),
    Key( [], "XF86AudioNext", lazy.spawn("mpc next")),
    Key( [], "XF86AudioPlay", lazy.spawn("mpc toggle")),
    # Change monitor brightness if keyboard has keys
    Key( [], "XF86MonBrightnessUp", lazy.spawn("xbacklight +5")),
    Key( [], "XF86MonBrightnessDown", lazy.spawn("xbacklight -4")),

    # also allow changing volume and music the old fashioned way
    Key( [m], "Left", lazy.spawn("pulsemixer --change-volume -5")),
    Key( [m], "Right", lazy.spawn("pulsemixer --change-volume +5")),
    # mpd controls
    Key( [m], "minus", lazy.spawn("mpc volume -10")),
    Key( [m], "plus", lazy.spawn("mpc volume +10")),
    Key( [m], "less", lazy.spawn("mpc prev")),
    Key( [m, s], "less", lazy.spawn("mpc next")),
    Key( [m, s], "p", lazy.spawn("mpc toggle")),
]

mouse = [
    Drag( [m], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag( [m], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click( [m], "Button2", lazy.window.bring_to_front()),
]

# specify group names, and use the group name list to generate an
# appropriate set of bindings for group switching.
groups = [ Group(str(i)) for i in (1, 2, 3, 4, 5, 6, 7, 8, 9, 0)]
for i in groups:
    keys.append(Key([m], i.name, lazy.group[i.name].toscreen()) )
    keys.append(Key([m, s], i.name, lazy.window.togroup(i.name)) )

border = dict(
    border_normal='#383838',
    border_focus='#a1b56c',
    border_width=2,
)

# Layout instances:
layouts = [
    layout.MonadTall(**border),
    layout.Max(),
]

floating_layout = layout.Floating(float_rules=[
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
    {'wmclass': 'confirmreset'},  # gitk
    {'wmclass': 'makebranch'},  # gitk
    {'wmclass': 'maketag'},  # gitk
    {'wname': 'branchdialog'},  # gitk
    {'wname': 'pinentry'},  # GPG key password entry
    {'wmclass': 'ssh-askpass'},  # ssh-askpass
])

widget_defaults = dict(
    font='sans',
    fontsize=14,
    padding=3,
)    

# Define StatusBar
def getBar():
    return bar.Bar([
        widget.GroupBox(
            margin_x = 0,
            margin_y = 2,
            borderwidth = 0,
            padding_x = 10,
            rounded = False,
            disable_drag = True,
            highlight_method = "block",
            this_current_screen_border = "a1b56c",
            this_screen_border = "505a36",
            other_screen_border = "888888",
            inactive = "606060",
        ),
        widget.Prompt(),
        widget.WindowName(foreground = "a0a0a0",),
        widget.Notify(),
        widget.TextBox(
            text = "B:",
            foreground = foreground,
            background = red,
        ),
        widget.Battery(
            foreground = foreground,
            background = red,
            low_foreground = white,
            low_percentage = 0.15,
            update_delay = 10,
            charge_char = "+",
            discharge_char = "-",
        ),
        widget.TextBox(
            text = "N:",
            foreground = foreground,
            background = red,
        ),
        widget.Wlan(
            interface = "wlo1",
            foreground = foreground,
            background = red,
        ),
        widget.Net(
            interface = "wlo1",
            foreground = white,
            background = red,
        ),
        widget.TextBox(
            text = "C:",
            foreground = foreground,
            background = yellow,
        ),
        widget.CPUGraph(
            line_width = 1,
            foreground = foreground,
            background = yellow,
        ),
        widget.TextBox(
            text = "M:",
            foreground = foreground,
            background = yellow,
        ),
        widget.MemoryGraph(
            line_width = 1,
            foreground = foreground,
            background = yellow,
        ),
        widget.TextBox(
            text = "V:",
            foreground = foreground,
            background = yellow,
        ),
        widget.Volume(
            foreground = foreground,
            background = yellow,
        ),
        widget.Clock(
            format = "%a %d %b %H:%M:%S",
            foreground = foreground,
            background = blue,
        ),
        widget.Systray(
            foreground = foreground,
            background = blue,
        ),
    ], 20)

screens = [
    Screen(
        top = getBar()
    ),
    Screen(
        top = getBar()
    ),
    Screen(
        top = getBar()
    ),
]

def main(self):
    pass

