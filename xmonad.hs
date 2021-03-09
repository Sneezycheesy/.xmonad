{-# LANGUAGE UnicodeSyntax #-}

--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

-- ACTIONS

-- Hooks

-- Layouts

-- Layouts modifiers

-- DEFAULTS

import qualified Data.Map as M
import Graphics.X11.ExtraTypes.XF86
-- Border on one side imports

import SideDecorations
import System.Exit
import System.IO
import XMonad
import XMonad.Actions.CopyWindow (kill1, killAllOtherCopies)
import XMonad.Actions.CycleWS
import XMonad.Actions.GridSelect
import XMonad.Actions.MouseResize
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves (rotAllDown, rotSlavesDown)
import qualified XMonad.Actions.Search as S
import XMonad.Actions.SpawnOn
import qualified XMonad.Actions.TreeSelect as TS
import XMonad.Actions.Warp
import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Actions.WithAll (killAll, sinkAll)
import XMonad.Config.Desktop
import XMonad.Core
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.InsertPosition
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers (doFullFloat, isFullscreen)
import XMonad.Hooks.ServerMode
import XMonad.Hooks.SetWMName
import XMonad.Hooks.WorkspaceHistory
import XMonad.Layout.Decoration
import XMonad.Layout.Fullscreen hiding (fullscreenEventHook)
import XMonad.Layout.Gaps
import XMonad.Layout.GridVariants (Grid (Grid))
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (decreaseLimit, increaseLimit, limitWindows)
import XMonad.Layout.Magnifier
import XMonad.Layout.MultiToggle (EOT (EOT), mkToggle, single, (??))
import qualified XMonad.Layout.MultiToggle as MT (Toggle (..))
import XMonad.Layout.MultiToggle.Instances (StdTransformers (MIRROR, NBFULL, NOBORDERS))
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.ResizableTile
import XMonad.Layout.ShowWName
import XMonad.Layout.Simplest
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spacing
import XMonad.Layout.Spiral
import XMonad.Layout.SubLayouts
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import qualified XMonad.Layout.ToggleLayouts as T (ToggleLayout (Toggle), toggleLayouts)
import XMonad.Layout.WindowArranger (WindowArrangerMsg (..), windowArrange)
import XMonad.Layout.WindowNavigation
import qualified XMonad.StackSet as W
import XMonad.Util.Cursor
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.SpawnOnce
import XMonad.Util.Types

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
-- VARIABLES
myFont :: String
myFont = "xft:Mononoki Nerd Font:bold:size=9:antialias=true:hinting=true"

myTerminal = "kitty"

setSmartSpacing :: Bool
setSmartSpacing = True

setScreenSpacingEnabled :: Bool
setScreenSpacingEnabled = True

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth = 0

myMarginWidth = 0

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask = mod1Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
--xmobarEscape = concatMap doubleLts
--  where doubleLts '<' = "<<"
--        doubleLts x   = [x]

myWorkspaces = ["1: Main", "2: Dev", "3: Dev64", "4: Social", "5: Sicial", "6: Terminals", "7: Kitties", "8: Text", "9: Media", "10: Games", "11: Misc", "12: What"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor = "#903400"

myFocusedBorderColor = "#ff6f00"

myInactiveBorderColor = "#000"

------------------------------------------------------------------------
-- Event Masks:

-- | The client events that xmonad is interested in
myClientMask :: EventMask
myClientMask = structureNotifyMask .|. enterWindowMask .|. propertyChangeMask

-- | The root events that xmonad is interested in
myRootMask :: EventMask
myRootMask =
  substructureRedirectMask .|. substructureNotifyMask
    .|. enterWindowMask
    .|. leaveWindowMask
    .|. structureNotifyMask
    .|. buttonPressMask

userDir :: [Char]
userDir = "$HOME/"

xmonadDir :: [Char]
xmonadDir = ".xmonad/"

scriptDir :: [Char]
scriptDir = userDir ++ xmonadDir ++ "scripts/"

xmobarDir :: [Char]
xmobarDir = userDir ++ xmonadDir ++ "xmobar/"

------------------------------------------------------------------------

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@XConfig {XMonad.modMask = modm} =
  M.fromList $
    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf),
      -- launch dmenu
      ((modm, xK_p), spawn "dmenu_run"),
      -- launch gmrun
      ((modm .|. shiftMask, xK_p), spawn "gmrun"),
      -- close focused window
      ((modm .|. shiftMask, xK_c), kill),
      -- Rotate through the available layout algorithms
      ((modm, xK_space), sendMessage NextLayout),
      --  Reset the layouts on the current workspace to default
      ((modm .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf),
      -- Resize viewed windows to the correct size
      ((modm, xK_n), refresh),
      -- Move focus to the next window
      ((modm, xK_Tab), windows W.focusDown),
      -- Move focus to the next window
      ((modm, xK_j), windows W.focusDown),
      -- Move focus to the previous window
      ((modm, xK_k), windows W.focusUp),
      -- Move focus to the master window
      ((modm, xK_m), windows W.focusMaster),
      -- Swap the focused window and the master window
      ((modm, xK_Return), windows W.swapMaster),
      -- Swap the focused window with the next window
      ((modm .|. shiftMask, xK_j), windows W.swapDown),
      -- Swap the focused window with the previous window
      ((modm .|. shiftMask, xK_k), windows W.swapUp),
      -- Shrink the master area
      ((modm, xK_h), sendMessage Shrink),
      -- Expand the master area
      ((modm, xK_l), sendMessage Expand),
      -- Push window back into tiling
      ((modm, xK_t), withFocused $ windows . W.sink),
      -- Increment the number of windows in the master area
      ((modm, xK_comma), sendMessage (IncMasterN 1)),
      -- Deincrement the number of windows in the master area
      ((modm, xK_period), sendMessage (IncMasterN (-1))),
      -- Toggle the status bar gap
      -- Use this binding with avoidStruts from Hooks.ManageDocks.
      -- See also the statusBar function from Hooks.DynamicLog.
      --
      -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

      -- MEDIA
      -- Control volume

      -- Volume OUTPUT
      ((0, xF86XK_AudioMute), spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle"),
      ((0, xF86XK_AudioLowerVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ -1%"),
      ((0, xF86XK_AudioRaiseVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ +1%"),
      -- Volume INPUT
      ((mod4Mask, xF86XK_AudioMute), spawn "pactl set-source-mute @DEFAULT_SOURCE@ toggle"),
      ((mod4Mask, xF86XK_AudioLowerVolume), spawn "pactl set-source-volume @DEFAULT_SOURCE@ -1%"),
      ((mod4Mask, xF86XK_AudioRaiseVolume), spawn "pactl set-source-volume @DEFAULT_SOURCE@ +1%"),
      -- Control play/pause/next/prev
      -- Global
      ((0, xF86XK_AudioPlay), spawn "playerctl -a -i firefox,google-chrome,qutebrowser play-pause"),
      ((0, xF86XK_AudioStop), spawn "playerctl stop"),
      ((0, xF86XK_AudioNext), spawn "playerctl next"),
      ((0, xF86XK_AudioPrev), spawn "playerctl previous"),
      ((mod4Mask, xF86XK_AudioPlay), spawn "playerctl -a pause; if [ -e \"/tmp/mpvsocket\" ]; then echo '{ \"command\": [\"set_property\", \"pause\", true] }' | socat - /tmp/mpvsocket; fi"),
      -- mpv
      ((controlMask, xF86XK_AudioPlay), spawn "if [ -e \"/tmp/mpvsocket\" ]; then echo '{ \"command\": [\"cycle\", \"pause\"] }' | socat - /tmp/mpvsocket; fi"),
      ((controlMask, xF86XK_AudioNext), spawn "if [ -e \"/tmp/mpvsocket\" ]; then echo '{ \"command\": [\"playlist-next\"] }' | socat - /tmp/mpvsocket; echo '{ \"command\": [\"set_property\", \"pause\", false] }' | socat - /tmp/mpvsocket; fi"),
      ((controlMask, xF86XK_AudioPrev), spawn "if [ -e \"/tmp/mpvsocket\" ]; then echo '{ \"command\": [\"playlist-prev\"] }' | socat - /tmp/mpvsocket; echo '{ \"command\": [\"set_property\", \"pause\", false] }' | socat - /tmp/mpvsocket; fi"),
      ((controlMask, xF86XK_AudioMute), spawn "if [ -e \"/tmp/mpvsocket\" ]; then echo '{ \"command\": [\"cycle\", \"mute\"] }' | socat - /tmp/mpvsocket; fi"),
      -- Change Audio in- and outputs
      ((mod4Mask, xK_1), spawn "pactl set-default-sink \"alsa_output.pci-0000_00_14.2.analog-stereo\" && xmonad --restart"), -- Speakers (Analog port)
      ((mod4Mask, xK_2), spawn "pactl set-default-sink \"alsa_output.usb-Logitech_PRO_X_000000000000-00.analog-stereo\" && xmonad --restart"), -- Headset (USB device)
      ((mod4Mask, xK_3), spawn "sh /usr/share/scripts/bluetooth.sh"), -- Bluetooth device (whichever is connected, not tested on multiple connections)
      ((mod4Mask .|. controlMask, xK_1), spawn "pactl set-default-source \"alsa_input.usb-Logitech_PRO_X_000000000000-00.multichannel-input\" && xmonad --restart"), -- Input headset (USB device)
      ((mod4Mask .|. controlMask, xK_2), spawn "pactl set-default-source \"alsa_input.usb-OmniVision_Technologies__Inc._USB_Camera-B4.09.24.1-01.multichannel-input\" && xmonad --restart"), -- Input webcam (USB device)

      -- SYSTEMTRAY FOR NETWORK STATUS
      ((modm .|. controlMask, xK_s), spawn $ "sh " ++ scriptDir ++ "stalonetray.sh"),
      -- SESSION
      ((mod4Mask .|. shiftMask, xK_s), spawn "oblogout"),
      ((modm .|. controlMask, xK_l), spawn $ "sh " ++ scriptDir ++ "lock.sh"),
      -- Quit xmonad
      ((modm .|. shiftMask, xK_KP_Subtract), io exitSuccess),
      -- Restart xmonad
      ((modm, xK_KP_Subtract), spawn "xmonad --recompile; xmonad --restart"),
      -- APPLICATIONS
      ((mod4Mask, xK_a), spawn "audacious"),
      ((mod4Mask, xK_b), spawn "blueman-manager"),
      ((mod4Mask, xK_c), spawn "code"),
      ((mod4Mask, xK_d), spawn "discord"),
      ((mod4Mask, xK_e), spawn "kitty -e ranger"),
      ((mod4Mask, xK_f), spawn "firefox"),
      ((mod4Mask .|. modm, xK_f), spawn "firefox --private-window"),
      ((mod4Mask, xK_g), spawn "google-chrome-stable"),
      ((mod4Mask, xK_i), spawn "signal-desktop"),
      ((mod4Mask, xK_l), spawn "lutris"),
      ((mod4Mask, xK_m), spawn "mailspring"),
      ((mod4Mask, xK_n), spawn "gimp"),
      ((mod4Mask, xK_p), spawn "passmenu"),
      ((controlMask .|. mod4Mask, xK_p), spawn "passgen | tr -d '\n' | xclip -selection clipboard"),
      ((mod4Mask, xK_q), spawn "qutebrowser"),
      ((mod4Mask .|. controlMask, xK_q), spawn "qutebrowser --target private-window"),
      ((mod4Mask, xK_s), spawn "skypeforlinux"),
      ((controlMask .|. mod4Mask, xK_s), spawn "steam-native"),
      ((mod4Mask, xK_t), spawn "telegram-desktop"),
      ((mod4Mask, xK_u), spawn "subl"),
      ((mod4Mask, xK_v), spawn "virtualbox"),
      ((mod4Mask, xK_w), spawn "VBoxManage startvm 'Winblows'"),
      ((mod4Mask, xK_y), spawn "firefox --new-window https://youtube.com"),
      ((0, xK_Print), spawn "sh /usr/share/scripts/screenshot.sh select"),
      ((controlMask, xK_Print), spawn "sh /usr/share/scripts/screenshot.sh current"),
      ((mod4Mask, xK_Print), spawn "sh /usr/share/scripts/screenshot.sh full"),
      -- SWITCH NEXT/PREV WORKSPACES
      ((mod4Mask, xK_Left), prevWS),
      ((mod4Mask, xK_Right), nextWS),
      -- Run xmessage with a summary of the default keybindings (useful for beginners)
      ((modm .|. shiftMask, xK_slash), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))
    ]
      ++
      --
      -- mod-[1..9], Switch to workspace N
      -- mod-shift-[1..9], Move client to workspace N
      --
      [ ((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1, xK_2, xK_3, xK_4, xK_5, xK_6, xK_7, xK_8, xK_9, xK_0, xK_minus, xK_equal],
          (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
      ]
      ++
      --
      -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
      -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
      --
      [ ((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f) >> spawn ("sh " ++ scriptDir ++ "move_mouse.sh \"" ++ show sc ++ "\""))
        | (key, sc) <- zip [xK_q, xK_w, xK_e, xK_r] [0 ..],
          (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
      ]

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings XConfig {XMonad.modMask = modm} =
  M.fromList
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ( (modm, button1),
        \w ->
          focus w >> mouseMoveWindow w
            >> windows W.shiftMaster
      ),
      -- mod-button2, Raise the window to the top of the stack
      ((modm, button2), \w -> focus w >> windows W.shiftMaster),
      -- mod-button3, Set the window to floating mode and resize by dragging
      ( (modm, button3),
        \w ->
          focus w >> mouseResizeWindow w
            >> windows W.shiftMaster
      )
      -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------

-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
-- myLayout = spacingRaw False (Border 7 7 7 7) True (Border 7 7 7 7) True $ gaps [(U,18)] $ tiled ||| Mirror tiled ||| Full
--   where
--      -- default tiling algorithm partitions the screen into two panes
--      tiled   = Tall nmaster delta ratio

--      -- The default number of windows in the master pane
--      nmaster = 1

--      -- Default proportion of screen occupied by master pane
--      ratio   = 1/2

--      -- Percent of screen to increment by when resizing panes
--      delta   = 2/100

mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- Below is a variation of the above except no borders are applied
-- if fewer than two windows. So a single window has no gaps.
mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

-- Defining a bunch of layouts, many that I don't use.
tall =
  renamed [Replace "tall"] $
    windowNavigation
    --    $ addTabs shrinkText myTabTheme
    $
      limitWindows 12 $
        mySpacing' 5 $
          ResizableTall 1 (3 / 100) 0.50 []

-- magnify  = renamed [Replace "magnify"]
--            $ windowNavigation
--            $ addTabs shrinkText myTabTheme
--            $ subLayout [] (smartBorders Simplest)
--            $ magnifier
--            $ limitWindows 12
--            $ mySpacing 8
--            $ ResizableTall 1 (3/100) (1/2) []
-- monocle  = renamed [Replace "monocle"]
--            $ windowNavigation
--            $ addTabs shrinkText myTabTheme
--            $ subLayout [] (smartBorders Simplest)
--            $ limitWindows 20 Full
-- floats   = renamed [Replace "floats"]
--            $ windowNavigation
--            $ addTabs shrinkText myTabTheme
--            $ subLayout [] (smartBorders Simplest)
--            $ limitWindows 20 simplestFloat
-- grid     = renamed [Replace "grid"]
--            $ windowNavigation
--            $ addTabs shrinkText myTabTheme
--            $ subLayout [] (smartBorders Simplest)
--            $ limitWindows 12
--            $ mySpacing 8
--            $ mkToggle (single MIRROR)
--            $ Grid (16/10)
-- spirals  = renamed [Replace "spirals"]
--            $ windowNavigation
--            $ addTabs shrinkText myTabTheme
--            $ subLayout [] (smartBorders Simplest)
--            $ mySpacing' 8
--            $ spiral (6/7)
-- threeCol = renamed [Replace "threeCol"]
--            $ windowNavigation
--            $ addTabs shrinkText myTabTheme
--            $ subLayout [] (smartBorders Simplest)
--            $ limitWindows 7
--            $ mySpacing' 4
--            $ ThreeCol 1 (3/100) (1/2)
threeRow =
  renamed [Replace "threeRow"] $
    windowNavigation $
      addTabs shrinkText myTabTheme $
        subLayout [] (smartBorders Simplest) $
          limitWindows 7 $
            mySpacing' 4
            -- Mirror takes a layout and rotates it by 90 degrees.
            -- So we are applying Mirror to the ThreeCol layout.
            $
              Mirror $
                ThreeCol 1 (3 / 100) 0.80

tabs =
  renamed [Replace "tabs"]
  -- I cannot add spacing to this layout because it will
  -- add spacing between window and tabs which looks bad.
  $
    tabbed shrinkText myTabTheme

myTabTheme =
  def
    { fontName = myFont,
      activeColor = "#46d9ff", --46d9ff
      inactiveColor = "#313846",
      activeBorderColor = "#98be65", --98be65
      inactiveBorderColor = "",
      activeTextColor = "#282c34",
      inactiveTextColor = "#d0d0d0",
      decoWidth = 2
    }

-- Theme for showWName which prints current workspace when you change workspaces.
myShowWNameTheme :: SWNConfig
myShowWNameTheme =
  def
    { swn_font = "xft:Ubuntu:bold:size=60",
      swn_fade = 1.0,
      swn_bgcolor = "#1c1f24",
      swn_color = "#ffffff"
    }

-- The layout hook
myLayoutHook =
  avoidStruts $
    mouseResize $
      windowArrange $
        mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
  where
    -- I've commented out the layouts I don't use.
    myDefaultLayout =
      myDecorate tall
        ||| noBorders Full
        --  ||| magnify
        --  ||| noBorders monocle
        --  ||| floats
        ||| noBorders tabs
        --  ||| grid
        --  ||| spirals
        --  ||| threeCol
        ||| myDecorate threeRow

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook =
  composeAll
    [ className =? "Code" --> doShift "2: Dev",
      className =? "discord" --> doShift "4: Social",
      className =? "Skype" --> doShift "4: Social",
      className =? "ferdi" --> doShift "4: Social",
      className =? "Whatsapp" --> doShift "5: Sicial",
      className =? "TelegramDesktop" --> doShift "4: Social",
      className =? "signal" --> doShift "4: Social",
      className =? "Signal" --> doShift "4: Social",
      className =? "wpsoffice" --> doShift "8: Text",
      className =? "Wpsoffice" --> doShift "8: Text",
      -- , className =? "firefox"                    --> doShift "4: Media"
      className =? "audacious" --> doShift "9: Media",
      className =? "Audacious" --> doShift "9: Media",
      className =? "kitty" <&&> resource =? "cmus v2.8.0" --> doShift "9: Media",
      className =? "mpv" --> doShift "9: Media",
      className =? "whatsapp-nativefier-d52542" --> doShift "12: What",
      className =? "lxterminal" --> doShift "12: What",
      className =? "Lxterminal" --> doShift "12: What",
      -- Move Steam apps to workspace 10
      className =? "minecraft" --> doShift "10: Games",
      className =? "steam_app_271590" --> doShift "10: Games", -- GTA5 client
      className =? "steam_app_238960" --> doShift "10: Games", -- Path of Exile client
      className =? "steam_app_270880" --> doShift "10: Games", -- ATS client
      className =? "steam_app_227300" --> doShift "10: Games", -- ETS2 client
      className =? "wow.exe" --> doShift "10: Games", -- WoW client
      className =? "spellbreak.exe" --> doShift "10: Games", -- Spellbreak client
      className =? "epicgameslauncher.exe" --> doShift "11: Misc", -- Epic Games Launcher
      className =? "battle.net.exe" --> doShift "11: Misc", -- Blizzard
      className =? "explorer.exe" --> doShift "11: Misc", -- Wine
      className =? "steam" --> doShift "11: Misc", -- Steam

      -- Start floating windows for finer behaviour
      -- className =? "mpv" --> doFloat,
      className =? "wpsoffice" --> doFloat,
      className =? "lxterminal" --> doFloat,
      className =? "Lxterminal" --> doFloat,
      className =? "MPlayer" --> doFloat,
      className =? "Albert" --> doFloat,
      -- , className =? "Gimp"                                     --> doFloat
      className =? "Oblogout" --> doFloat,
      className =? "notepadqq-bin" --> doFloat,
      className =? "Toolkit" --> doFloat,
      className =? "firefox" <&&> resource =? "Toolkit" --> doFloat,
      --, className =? "VirtualBox Machine"         --> doFloat
      resource =? "desktop_window" --> doIgnore,
      resource =? "kdesktop" --> doIgnore
    ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook

--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
--myLogHook = return ()

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = do
  sequence_
    [ spawnOnce "sh /home/joshii/.screenlayout/default-amd.sh",
      spawnOnce "xdotool mousemove 960 540",
      spawnOnce "twmnd",
      spawnOnce "/usr/bin/numlockx on",
      -- , spawnOnce "ferdi"
      spawnOnce "albert",
      spawnOnce "volnoti",
      spawnOnce "discord --start-minimized",
      spawnOnce "telegram-desktop -startintray",
      spawnOnce "skypeforlinux",
      -- spawnOnce "whatsapp-nativefier-dark; sleep 3; xdotool windowkill 31457281;",
      spawnOnce "nitrogen --restore",
      spawnOnce "signal-desktop --start-in-tray",
      spawnOnce "setxkbmap us -variant alt-intl &",
      spawnOnce "xsetroot -cursor_name left_ptr",
      spawnOnce "mailspring -b",
      spawnOnce "pass init 3DF562B19CD657FED5CA17B1F88D03D7F1D36D04 &",
      spawnOnce "xset -dpms && xset s off"
    ]

------------------------------------------------------------------------
-- Command to launch the bar.
myBar = "xmobar"

-- Custom PP, configure it as you like. It determines what is being written to the bar.
-- myPP = xmobarPP { ppCurrent = xmobarColor "#429942" "" . wrap "<" ">" }

-- Key binding to toggle the gap for the bar.
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

------------------------------------------------------------------------

-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--

main = do
  xmproc0 <- spawnPipe $ "/usr/bin/xmobar -f with_alsa -n xmonad -x 0 " ++ xmobarDir ++ ".xmobarrc"
  xmproc1 <- spawnPipe $ "/usr/bin/xmobar -f with_alsa -n xmonad -x 1 " ++ xmobarDir ++ ".xmobarrc"
  xmproc2 <- spawnPipe $ "/usr/bin/xmobar -f with_alsa -n xmonad -x 2 " ++ xmobarDir ++ ".xmobarrc"
  xmonad $
    docks $
      defaults
        { logHook =
            dynamicLogWithPP $
              def
                { ppOutput = \x -> hPutStrLn xmproc0 x >> hPutStrLn xmproc1 x >> hPutStrLn xmproc2 x,
                  ppCurrent = xmobarColor "#5afc5a" "" . wrap "[ " " ]",
                  -- , ppHiddenNoWindows = xmobarColor "#b3afc2" "" . wrap "| " ""
                  ppHidden = xmobarColor "#666" "",
                  ppTitle = xmobarColor "#0c1628" "" . shorten 0,
                  ppVisible = xmobarColor "#75b1b5" "",
                  ppUrgent = xmobarColor "red" "yellow",
                  ppLayout = xmobarColor "#0c1628" ""
                }
        }

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--

defaults =
  def
    { -- simple stuff
      terminal = myTerminal,
      focusFollowsMouse = myFocusFollowsMouse,
      clickJustFocuses = myClickJustFocuses,
      borderWidth = myBorderWidth,
      modMask = myModMask,
      workspaces = myWorkspaces,
      normalBorderColor = myNormalBorderColor,
      focusedBorderColor = myFocusedBorderColor,
      clientMask = myClientMask,
      rootMask = myRootMask,
      -- key bindings
      keys = myKeys,
      mouseBindings = myMouseBindings,
      -- hooks, layouts
      layoutHook = myLayoutHook,
      manageHook = insertPosition End Newer <+> myManageHook,
      handleEventHook = myEventHook,
      startupHook = myStartupHook
    }

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help =
  unlines
    [ "The default modifier key is 'alt'. Default keybindings:",
      -- Red taskbar #ff6c6b
      -- green taskbar #98be65
      -- blue taskbar #51afef
      -- orange taskbar #ecbe7b
      -- purple taskbar #dd42f5
      -- gray taskbar #b3afc2
      -- xmobar background #282c34
      "",
      "-- launching and killing programs",
      "mod-Shift-Enter  Launch xterminal",
      "mod-p            Launch dmenu",
      "mod-Shift-p      Launch gmrun",
      "mod-Shift-c      Close/kill the focused window",
      "mod-Space        Rotate through the available layout algorithms",
      "mod-Shift-Space  Reset the layouts on the current workSpace to default",
      "mod-n            Resize/refresh viewed windows to the correct size",
      "",
      "-- move focus up or down the window stack",
      "mod-Tab        Move focus to the next window",
      "mod-Shift-Tab  Move focus to the previous window",
      "mod-j          Move focus to the next window",
      "mod-k          Move focus to the previous window",
      "mod-m          Move focus to the master window",
      "",
      "-- modifying the window order",
      "mod-Return   Swap the focused window and the master window",
      "mod-Shift-j  Swap the focused window with the next window",
      "mod-Shift-k  Swap the focused window with the previous window",
      "",
      "-- resizing the master/slave ratio",
      "mod-h  Shrink the master area",
      "mod-l  Expand the master area",
      "",
      "-- floating layer support",
      "mod-t  Push window back into tiling; unfloat and re-tile it",
      "",
      "-- increase or decrease number of windows in the master area",
      "mod-comma  (mod-,)   Increment the number of windows in the master area",
      "mod-period (mod-.)   Deincrement the number of windows in the master area",
      "",
      "-- quit, or restart",
      "mod-Shift-q  Quit xmonad",
      "mod-q        Restart xmonad",
      "mod-[1..9]   Switch to workSpace N",
      "",
      "-- Workspaces & screens",
      "mod-Shift-[1..9]   Move client to workspace N",
      "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
      "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
      "",
      "-- Mouse bindings: default actions bound to mouse events",
      "mod-button1  Set the window to floating mode and move by dragging",
      "mod-button2  Raise the window to the top of the stack",
      "mod-button3  Set the window to floating mode and resize by dragging"
    ]
