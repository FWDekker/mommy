## sample1.png
1. Install fish, and add the following to `~/.config/fish/functions/fish_right_prompt.fish`:
   ```shell
   function fish_right_prompt
       mommy -1 -s $status
   end
   ```
2. Use the following settings in `~/.config/mommy/config.sh`:
   ```shell
   MOMMY_COMPLIMENTS_ENABLED=0;MOMMY_ENCOURAGEMENTS="it's okay to make mistakes";MOMMY_COLOR="lolcat"
   ```
3. Open Konsole, set font size to 32, set window size to 60x12, and hide window borders.
4. Run
   ```shell
   sudo apt update
   ```
5. Enter the wrong password three times.
6. Take a screenshot.


## sample2.png
1. Install zsh, and add the following to `~/.zshrc`:
   ```shell
   set -o PROMPT_SUBST
   RPS1='$(mommy -1 -s $?)'
   ```
2. Use the following settings in `~/.config/mommy/config.sh`:
   ```shell
   MOMMY_COMPLIMENTS_ENABLED=0;MOMMY_ENCOURAGEMENTS="never give up, my love";MOMMY_COLOR=""
   ```
3. Open Konsole, set font size to 32, set window size to 60x12, and hide window borders.
4. Run
   ```shell
   git clone git@github.com/nyancrimew/noflylist.git
   ```
5. Take a screenshot.
