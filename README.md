# My Dotfiles


<table>
    <tr>
        <th>Info</th>
        <th>Demo</th>
    </tr>
    <tr>
        <td style="vertical-align: middle;">
            <table>
                <tr>
                    <td>OS</td>
                    <td><a href="https://archlinux.org">Arch</a></td>
                </tr>
                <!-- <tr> -->
                <!--     <td>WM</td> -->
                <!--     <td><a href="https://qtile.org">Qtile</a></td> -->
                <!-- </tr> -->
                <tr>
                    <td>WM</td>
                    <td><a href="https://hypr.land">Hyrpland</a></td>
                </tr>
                <tr>
                    <td>Status Bar</td>
                    <td><a href="https://github.com/Alexays/Waybar">Waybar</a></td>
                </tr>
                <tr>
                    <td>Terminal</td>
                    <td><a href="https://ghostty.org">Ghostty</a></td>
                    <!-- <td><a href="https://sw.kovidgoyal.net/kitty">Kitty</a></td> -->
                    <!-- <td><a href="https://alacritty.org">Alacritty</a></td> -->
                </tr>
                <tr>
                    <td>Shell</td>
                    <td><a href="https://www.zsh.org">Zsh</a></td>
                </tr>
                <tr>
                    <td>Shell Theme</td>
                    <td><a href="https://starship.rs">Starship</a></td>
                    <!-- <td><a href="https://github.com/romkatv/powerlevel10k">Powerlevel10k</a></td> -->
                </tr>
                <tr>
                    <td>Editor</td>
                    <td><a href="https://neovim.io">Neovim</a></td>
                </tr>
                <tr>
                    <td>File&nbsp;Manager</td>
                    <td><a href="https://yazi-rs.github.io">Yazi</a></td>
                    <!-- <td><a href="https://github.com/gokcehan/lf">lf</a></td> -->
                </tr>
            </table>
        </td>
        <td>
            <!-- Hyrpland Screenshot: -->
            <img width="1920" height="1080" alt="screenshot" src="https://github.com/user-attachments/assets/1b177d73-ad4d-4b53-97f7-3797b16fcf8f" />
            <!-- Qtile Screenshot: -->
            <!-- <img src="https://github.com/user-attachments/assets/eb0abb1e-0faf-4c0e-a62f-fee91766e5a8" alt="screenshot"> -->
        </td>
    </tr>
</table>


## How to install

1. Install `git` and `make`
2. Clone this repository to your home directory:
```
git clone --depth=1 https://github.com/trimclain/.dotfiles ~/.dotfiles
```
3. Install prerequisites:
```
cd ~/.dotfiles && make
```
4. Install dotfiles:
```
make install
```


## Note
Neovim config is in a [separate repository](https://github.com/trimclain/nvim).
