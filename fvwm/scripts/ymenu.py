#!/usr/bin/python
#
# Description: create different menus for Ydesk with icon caching
# Author: Victor Ananjevsky, 2007 - 2021
# License: GPL
#

import sys
import os
from glob import glob

import xdg.Menu
from xdg.DesktopEntry import *
from xdg.BaseDirectory import *

import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk, GdkPixbuf

# default size for cached icons
icon_size = 16

# default size of recent menu
recent_size = 15

def cache_icon (icon):
    ''' cache an icon  '''
    icon_file = "%s/%s.png" % (cache_path, os.path.basename(icon))
    if os.path.exists(icon_file):
        return
    try:
        icon_theme.load_icon(icon, icon_size, Gtk.IconLookupFlags.FORCE_SIZE).savev(icon_file, "png", [], [])
    except:
        pass

def print_dentry (de, prefix = ''):
    ''' output desktop entry '''
    if de.getHidden() or not de.getNoDisplay:
        return
    icon = de.getIcon()
    cache_icon(icon)
    cmd = de.getExec().rstrip('%FUfu')
    nm = de.getGenericName()
    t = de.getTerminal()
    if not nm:
        nm = de.getName()
    if (t):
        print('+ "%s%%%s.png%%" Exec exec $[infostore.term] -e "%s%s"' % (nm, os.path.basename(icon), prefix, cmd))
    else:
        print('+ "%s%%%s.png%%" Exec exec %s%s' % (nm, os.path.basename(icon), prefix, cmd))

def parse_menu (menu):
    ''' parse menu file '''
    print('DestroyMenu %s\nAddToMenu %s' % (menu, menu))

    for entry in menu.getEntries():
        if isinstance(entry, xdg.Menu.Menu):
            icon = entry.getIcon()
            cache_icon(icon)
            print('+ "%s%%%s.png%%" Popup "%s"' % (entry.getName(), os.path.basename(icon), entry))
        elif isinstance(entry, xdg.Menu.MenuEntry):
            desktop = DesktopEntry(entry.DesktopEntry.getFileName())
            print_dentry(desktop)
        else:
            pass

    for entry in menu.getEntries():
        if isinstance(entry, xdg.Menu.Menu):
            parse_menu(entry)

def parse_toplevel (menu):
    ''' parse menu file for embedding '''
    for entry in menu.getEntries():
        if isinstance(entry, xdg.Menu.Menu):
            icon = entry.getIcon()
            cache_icon(icon)
            print('+ "%s%%%s.png%%" Popup "%s"' % (entry.getName(), os.path.basename(icon), entry))
        elif isinstance(entry, xdg.Menu.MenuEntry):
            desktop = DesktopEntry(entry.DesktopEntry.getFileName())
            print_dentry(desktop)
        else:
            pass

def parse_recent ():
    ''' parse recently opened files '''
    print('DestroyMenu recreate RecentMenu\nAddToMenu RecentMenu')

    cnt = 1
    rm = Gtk.RecentManager()
    for rf in rm.get_items():
        print('+ "%d: %s" Exec exec xdg-open "%s"' % (cnt, rf.get_display_name(), rf.get_uri()))
        cnt += 1
        if (cnt > recent_size):
            break

def parse_qlaunch ():
    ''' parse recently opened files '''
    for f in sorted(glob("%s/ydesk/qlaunch/*.desktop" % xdg_data_home)):
        if f.endswith(".desktop"):
            desktop = DesktopEntry(f)
            icon = desktop.getIcon()
            cache_icon(icon)
            cmd = desktop.getExec().rstrip('%FUfu')
            print('+ "%s%%%s.png%%" Exec exec %s' % (desktop.getName(), os.path.basename(icon), cmd))

def parse_autostart ():
    ''' parse autostart items '''
    cmds = []
    for d in xdg_config_dirs:
        for f in glob("%s/autostart/*.desktop" % d):
            desktop = DesktopEntry(f)
            if not desktop.getHidden():
                cmds.append(desktop.getExec().rstrip('%FUfu'))
    for f in glob("%s/autostart/*.desktop" % xdg_config_home):
        desktop = DesktopEntry(f)
        cmd = desktop.getExec().rstrip('%FUfu')
        if not desktop.getHidden():
            cmds.append(cmd)
        else:
            try:
                cmds.remove(cmd)
            except ValueError:
                pass
    # output
    for c in set(cmds):
        print('+ I Exec exec %s' % c)

def parse_settings ():
    ''' create settings menu '''
    print('DestroyMenu SettingsMenu\nAddToMenu SettingsMenu')
    for d in xdg_data_dirs:
        for f in glob("%s/settings/*.desktop" % d):
            desktop = DesktopEntry(f)
            print_dentry(desktop, prefix="/usr/lib/ydesk/settings/")

# Start

cache_path = "%s/ydesk/fvwm/icons" % xdg_cache_home
icon_theme = Gtk.IconTheme.get_default()

if not os.path.exists(cache_path):
    os.makedirs(cache_path)

argc = 1
toplevel = False
if sys.argv[argc] == "-t":
    toplevel = True
    argc = 2

for arg in sys.argv[argc:]:
    if arg == "recent":
        parse_recent ()
    elif arg == "qlaunch":
        parse_qlaunch ()
    elif arg == "autostart":
        parse_autostart ()
    elif arg == "settings":
        parse_settings ()
    else:
        filename = ""
        if os.path.exists(arg):
            filename = arg
        else:
            tmpfile = "%s/menus/%s.menu" % (xdg_config_home, arg)
            if os.path.exists(tmpfile):
                filename = tmpfile
            else:
                for dir in xdg_config_dirs:
                    tmpfile = "%s/menus/%s.menu" % (dir, arg)
                    if os.path.exists(tmpfile):
                        filename = tmpfile
                        break
        if filename == "":
            break
        if toplevel:
            parse_toplevel(xdg.Menu.parse(filename))
        else:
            parse_menu(xdg.Menu.parse(filename))
