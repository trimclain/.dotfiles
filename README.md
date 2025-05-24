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
                    <td><a href="https://hyprland.org/">Hyrpland</a></td>
                </tr>
                <tr>
                    <td>Status Bar</td>
                    <td><a href="https://github.com/Alexays/Waybar">Waybar</a></td>
                </tr>
                <!-- <tr> -->
                <!--     <td>Terminal</td> -->
                <!--     <td><a href="https://sw.kovidgoyal.net/kitty/">Kitty</a></td> -->
                <!-- </tr> -->
                <tr>
                    <td>Terminal</td>
                    <td><a href="https://alacritty.org/">Alacritty</a></td>
                </tr>
                <tr>
                    <td>Shell</td>
                    <td><a href="https://www.zsh.org">Zsh</a></td>
                </tr>
                <tr>
                    <td>Shell Theme</td>
                    <td><a href="https://github.com/romkatv/powerlevel10k">Powerlevel10k</a></td>
                </tr>
                <tr>
                    <td>Editor</td>
                    <td><a href="https://neovim.io">Neovim</a></td>
                </tr>
                <!-- <tr> -->
                <!--     <td>File&nbspManager</td> -->
                <!--     <td><a href="https://github.com/gokcehan/lf">lf</a></td> -->
                <!-- </tr> -->
            </table>
        </td>
        <td>
            <!-- Qtile Screenshot: -->
            <!-- <img src="https://github.com/trimclain/.dotfiles/assets/84108846/12d5daeb-6cf2-483e-a71d-96ba29580350" alt="screenshot"> -->
            <!-- Hyrpland Screenshot: -->
            <!-- <img src="https://github.com/trimclain/.dotfiles/assets/84108846/8bea4b86-d94d-46a1-aa2d-f8aeef3d7b1e" alt="screenshot"> -->
            <!-- Qtile Screenshot: -->
            <img src="https://github.com/user-attachments/assets/eb0abb1e-0faf-4c0e-a62f-fee91766e5a8" alt="screenshot">
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
