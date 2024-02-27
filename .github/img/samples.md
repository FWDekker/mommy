## General settings
### Konsole
* Set font size to 32
* Set window size to 60x12
* Hide all toolbars, hide the title bar, and hide the frame.

### Screenshot
* Take a screenshot of the entire Konsole window.
* Resize the image to be 450px wide.


## bash.png
1. Add the following to `~/.bashrc`:
   ```shell
   PROMPT_COMMAND="mommy -1 -s \$?; $PROMPT_COMMAND"
   ```
2. Use the following settings in `~/.config/mommy/config.sh`:
   ```shell
   MOMMY_COMPLIMENTS_ENABLED="0";MOMMY_ENCOURAGEMENTS="it's okay to make mistakes"
   ```
3. Apply the Konsole settings described above.
4. Run
   ```shell
   ssh cia.gov
   ```
5. Take a screenshot as described above.
   

## fish.png
1. Install fish, and add the following to `~/.config/fish/functions/fish_right_prompt.fish`:
   ```shell
   function fish_right_prompt
       mommy -1 -s $status
   end
   ```
2. Use the following settings in `~/.config/mommy/config.sh`:
   ```shell
   MOMMY_COMPLIMENTS_ENABLED="0";MOMMY_ENCOURAGEMENTS="it's okay to make mistakes";MOMMY_COLOR="lolcat"
   ```
3. Apply the Konsole settings described above.
4. Run
   ```shell
   sudo apt update
   ```
5. Enter the wrong password three times.
6. Take a screenshot as described above.


## nushell.png
1. Install brew and nushell, and add the following to `~/.config/nushell/config.nu`:
   ```shell
   $env.PROMPT_COMMAND_RIGHT = {|| mommy -1 -s $env.LAST_EXIT_CODE }
   ```
2. Use the following settings in `~/.config/mommy/config.sh`:
   ```shell
   MOMMY_COMPLIMENTS_ENABLED="0";MOMMY_ENCOURAGEMENTS="just a little further, mommy knows you can do it"
   ```
3. Apply the Konsole settings described above.
4. Run
   ```shell
   rm -rf /
   ```
5. Take a screenshot as described above.


## zsh.png
1. Install zsh, and add the following to `~/.zshrc`:
   ```shell
   set -o PROMPT_SUBST
   RPS1='$(mommy -1 -s $?)'
   ```
2. Use the following settings in `~/.config/mommy/config.sh`:
   ```shell
   MOMMY_COMPLIMENTS_ENABLED="0";MOMMY_COLOR="";MOMMY_PREFIX="%F{005}";MOMMY_SUFFIX="~%f";MOMMY_ENCOURAGEMENTS="never give up, my love"
   ```
3. Apply the Konsole settings described above.
4. Run
   ```shell
   git clone git@github.com/nyancrimew/noflylist.git
   ```
5. Take a screenshot as described above.
