# Some of my fonts for quick access

In this folder you can find some of the fonts I used.<br>
It is highly recommended to use [NerdFonts](https://www.nerdfonts.com/).<br>
A good tool to install them on Linux/Mac is [getnf](https://github.com/ronniedroid/getnf).

# Note
Apparently a ton of icons I was using are only available in JetBrainsMonoComplete.

### My Debugging steps for future reference:

To get the missing codepoint ask Wezterm
For example I was missing \u{f655}.

To check how it looks use
```
printf '\UF655\n'
```

To find a font containing a charset for it
```
fc-list :charset=F655
```

### Additional Info
Charcode \u{2718} is supported in these fonts: https://www.fileformat.info/info/unicode/char/2718/fontsupport.htm <br>
For now I choose Terminus.
