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
                <tr>
                    <td>WM</td>
                    <td><a href="https://qtile.org">Qtile</a></td>
                </tr>
                <tr>
                    <td>Terminal</td>
                    <td><a href="https://sw.kovidgoyal.net/kitty/">Kitty</a></td>
                </tr>
                <tr>
                    <td>Shell</td>
                    <td><a href="https://www.zsh.org">Zsh</a></td>
                </tr>
                <tr>
                    <td>Editor</td>
                    <td><a href="https://neovim.io">Neovim</a></td>
                </tr>
                <tr>
                    <td>File&nbspManager</td>
                    <td><a href="https://github.com/gokcehan/lf">lf</a></td>
                </tr>
            </table>
        </td>
        <td>
            <img src="https://github.com/trimclain/.dotfiles/assets/84108846/12d5daeb-6cf2-483e-a71d-96ba29580350" alt="screenshot">
        </td>
    </tr>
</table>


## How to install

1. Install git and make
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
