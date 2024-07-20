## Requirements
- [Lovely](https://github.com/ethangreen-dev/lovely-injector) - a Balatro injector.

## Installation
1. Install [Lovely](https://github.com/ethangreen-dev/lovely-injector?tab=readme-ov-file#manual-installation).
2. Download the [latest release](https://github.com/stupxd/fixed-deck-size/releases/) of this mod.
3. Unzip the folder, and move it into the `%appdata%/Balatro/Mods` folder.
4. Restart the game to load the mod.

## Features
1. Limit amount of cards visible in your deck pile, to make it appear smaller. Default limit is 100 cards, which can be modified in [settings.lua](settings.lua) file.

![cards-pile-difference](git-assets/deck-pile.jpg)


2. Stack identical playing cards in deck view menu, which looks much cleaner and improves performance.

![stackable-cards-difference](git-assets/stackable-cards.jpg)

The text box with stack display can be customized in [settings.lua](settings.lua) file - you can change position and color of the `x`.

3. Hide off-screen cashout rows.

![off-screen-cashout](git-assets/off-screen-cashout.jpg)

Cashout process is additionally much faster & less laggy as you don't need to wait for off-screen cashout to be processed.

4. Properly formatted numbers in UI.

![numbers-formatting](git-assets/numbers-formatting.jpg)

Most numbers (money, jokers scaling, cashout, poker hand Chips x Mult) will now be formatted properly

- Big numbers are formatted with comas
- No rounding errors
- Scientific notation starts at 1 million, and is more compact to avoid UI breaking.

## Credits

[Jen Walter](https://github.com/cubeanimataz/) for the UI box on stacked cards.

