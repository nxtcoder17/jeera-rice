from qutebrowser.config.configfiles import ConfigAPI
from qutebrowser.config.config import ConfigContainer

def fromGlobals() -> tuple[ConfigAPI, ConfigContainer]:
    g = globals()
    return g["config"], g["c"]


config, c = fromGlobals()
config.load_autoconfig(True)

def nmap(key, command):
    config.bind(key, command, mode="normal")

def imap(key, command):
    config.bind(key, command, mode='insert')

def cmap(key, command):
    config.bind(key, command, mode='command')

def pmap(key, command):
    config.bind(key, command, mode='passthrough')

def unmap(*argv):
    for arg in argv:
        config.unbind(arg, mode="normal")

nmap(';', 'set-cmd-text :')

def hints():
    c.hints.chars = "asdfghjkl"
    c.hints.auto_follow = "always"
    c.hints.scatter =  False

    c.keyhint.delay = 100

hints()

def fonts():
    myFont = "Comic Code Ligatures Medium"

    c.fonts.hints = f"15px '{myFont}'"
    c.fonts.default_size = '16px'
    c.fonts.default_family = f'"{myFont}"'
    c.fonts.statusbar = f'11pt "{myFont}"'
    c.fonts.prompts = f"default_size {myFont}"
    c.fonts.completion.entry = f"default_size '{myFont}'"
    c.fonts.completion.entry = f"default_size '{myFont}'"
    c.fonts.tabs.selected = f"default_size '{myFont}'"
    c.fonts.tabs.unselected = f"15px '{myFont}'"
    c.fonts.contextmenu = c.fonts.hints

fonts()

def resetDefaultBindings():
    # tab-close
    unmap("d")
    nmap("dd", "tab-close")
    unmap("yy")

    # zooming, undo zooming
    unmap("+", "-", "=")
    nmap("<ctrl-=>", "zoom-in")
    nmap("<ctrl-->", "zoom-out")
    nmap("zz", "zoom")

    unmap("O")
    nmap("e", "set-cmd-text :open {url:pretty}")
    nmap("O", "set-cmd-text -s :open -t ")

def keybindings():
    resetDefaultBindings()

    # copying
    nmap("cc", "yank selection")
    nmap('yy', "yank url")

    # hints
    nmap("gi", "hint images")

    # new window
    unmap("<ctrl-n>")

    # url
    nmap("<ctrl-l>", "set-cmd-text :open {url:pretty}")

    # tabs
    nmap("tn", "tab-next")
    nmap("tp", "tab-prev")
    nmap("tt", "set-cmd-text -s :tab-select ")
    nmap('<alt-b>', 'hint links spawn gobble vivaldi-stable {hint-url}')

    imap("<escape>", "mode-enter normal")
    pmap("<escape>", "mode-enter normal")

    # watching videos
    nmap('cu','hint links spawn --userscript copy-url {hint-url}')
    nmap('M', 'hint links spawn --userscript youtube-to-yewtu {hint-url}')

keybindings()

def editor():
    c.editor.command = ['kitty', '-e', 'nvim', '-f','{file}', '-c', 'normal {line}G{column0}l']
    c.editor.remove_file = True

editor()

def options():
    # session
    c.auto_save.session = True
    c.session.lazy_restore = True

    c.downloads.position = "bottom"

    # zoom levels
    c.zoom.levels = ['25%', '33%', '50%', '67%', '75%', '90%', '100%', '110%', '125%', '150%', '175%', '200%', '250%', '300%', '400%', '500%']
    c.zoom.default = '125%'

    # colors:
    c.colors.webpage.darkmode.enabled = True
    # c.colors.webpage.darkmode.contrast = 0.5
    # c.colors.webpage.darkmode.contrast = 0.1717

    # source: https://www.reddit.com/r/qutebrowser/comments/o0dl4y/comment/h2p8dri/?utm_source=share&utm_medium=web2x&context=3
    # c.colors.webpage.darkmode.enabled = True
    # c.colors.webpage.darkmode.algorithm = 'lightness-hsl'
    # c.colors.webpage.darkmode.contrast = -.022
    # c.colors.webpage.darkmode.threshold.text = 150
    # c.colors.webpage.darkmode.threshold.background = 100
    # c.colors.webpage.darkmode.policy.images = 'always'
    # c.colors.webpage.darkmode.grayscale.images = 0.35

    # webpage, content, headers
    c.scrolling.smooth = False
    c.content.dns_prefetch = False
    c.content.autoplay = False
    c.content.geolocation = False
    c.content.javascript.enabled = True
    c.content.headers.user_agent = 'Mozilla/5.0 ({os_info}) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99 Safari/537.36'
    c.content.headers.do_not_track = True
    c.content.plugins = True
    c.content.blocking.adblock.lists = ['https://easylist.to/easylist/easylist.txt', 'https://easylist.to/easylist/easyprivacy.txt', 'https://easylist-downloads.adblockplus.org/easylistdutch.txt', 'https://easylist-downloads.adblockplus.org/abp-filters-anti-cv.txt', 'https://www.i-dont-care-about-cookies.eu/abp/', 'https://secure.fanboy.co.nz/fanboy-cookiemonster.txt', 'https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters-2021.txt']

    c.content.user_stylesheets = [
        "./stylesheets/dark-defaults-override.css",
    ]


    # tabs
    c.tabs.select_on_remove = "prev"

    # url
    c.url.start_pages = ["about:blank"]
    c.url.default_page = "about:blank"

    # mode settings
    # c.input.insert_mode.auto_leave = True
    c.input.insert_mode.auto_load = True


options()

# config.bind("kp", '''
#     jseval(function(){
#         var i, elements = document.querySelectorAll("body *");        
#         for (i =0; i < elements.length; i++) {
#             var pos = getComputedStyle(elements[i]).position;   
#             if (pos === "fixed" || pos == "sticky") {
#                 elements[i].parentNode.removeChild(elements[i]);
#             }
#         }
#     })()
# ''')

c.aliases = {
    "gh": "open https://github.com/nxtcoder17",
    "so": "config-source",
    "qr": "spawn --userscript qr-code.sh",
    "bw": "spawn --userscript qute-bitwarden",
}

# search engines
c.url.searchengines = {
    'DEFAULT': 'https://www.google.com/search?hl=en&q={}',
    'ddg': 'https://duckduckgo.com?q=!g+{}',
    'lh': 'http://localhost:{}',
    'yt': 'https://yewtu.be/search?q={}',
    'dh': 'https://hub.docker.com/search?q={}'
}


# colors
from themes.dracula import blood
blood(c,{
    'spacing': {
        'vertical': 6,
        'horizontal': 8,
    },
})

from themes.nxtcoder17 import useTheme
useTheme(c)
