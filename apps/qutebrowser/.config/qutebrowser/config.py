# type: ignore
config.load_autoconfig(True)
config.set("colors.webpage.darkmode.enabled", True)

## tuning configuration
c.auto_save.session = True
c.hints.chars = "asdfghjklie;"
c.scrolling.smooth = False

# autoplay
c.content.autoplay = False
c.content.geolocation = False

# modes
c.input.insert_mode.auto_leave = True
c.input.insert_mode.auto_load = False


myFont = "Comic Code Ligatures Medium"
c.fonts.hints = f"14px '{myFont}'"
c.fonts.default_size = '16px'
c.fonts.default_family = f'"{myFont}"'
c.fonts.statusbar = f'11pt "{myFont}"'
c.fonts.prompts = f"default_size {myFont}"
c.fonts.completion.entry = f"default_size '{myFont}'"
c.fonts.completion.entry = f"default_size '{myFont}'"
c.fonts.tabs.selected = f"default_size '{myFont}'"
c.fonts.tabs.unselected = f"14px '{myFont}'"

c.aliases = {"gh": "open https://github.com/nxtcoder17"}

# editor command
# c.editor.command = ['gvim', '-f', '{file}', '-c', 'normal {line}G{column0}l']
c.editor.command = ['kitty', '-e', 'nvim', '-f','{file}', '-c', 'normal {line}G{column0}l']
c.editor.remove_file = True

# search engines
c.url.searchengines = {
    'DEFAULT': 'https://duckduckgo.com?q=!g+{}',
    'lh': 'http://localhost{}',
    'yt': 'https://yewtu.be/search?q={}',
}


# keybindings
config.bind("gi", "hint inputs")
config.unbind("+")
config.unbind("-")
config.unbind("=")

c.zoom.default = '125%'
c.zoom.levels = ['25%', '33%', '50%', '67%', '75%', '90%', '100%', '110%', '125%', '150%', '175%', '200%', '250%', '300%', '400%', '500%']

config.bind("<ctrl-=>", "zoom-in")
config.bind("<ctrl-->", "zoom-out")
config.bind("zz", "zoom")

config.unbind("d")
config.bind("dd", "tab-close")

config.unbind("O")
config.bind("O", "set-cmd-text :open {url:pretty}")
config.bind("t", "set-cmd-text -s :open -t")
# config.bind("<tab>", "tab-next")
# config.bind("<shift+tab>", "tab-next")

config.unbind("<ctrl-n>")

config.bind("<ctrl-e>", "set-cmd-text -s :tab-select ", mode="command")

config.bind("<alt-k>", "set-cmd-text -s :quickmark-add ")

# colors
from themes.dracula import blood
blood(c,{
    'spacing': {
        'vertical': 6,
        'horizontal': 8,
    },
})
