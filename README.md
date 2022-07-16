# Lights Out

## Exercise Overview

**Lights Out** was (is?) a handheld electronic game produced by Tiger Electronics produced in the '90s. And you can even still [buy it today on Amazon](https://www.amazon.com/Tiger-Lights-Out-Handheld-Game/dp/B000UHABZC).

The game consists of a grid of 5x5 buttons that can light up, and the goal of the game is to turn all the lights off. Pressing each button would toggle the light of that button. (By toggle, we mean that if the light was on, it would turn off. If it was off, it would turn on.) But here's the catch: When pressing any button, that would automatically toggle the lights of *all adjacent buttons as well*.

It's worth skimming the game's [Wikipedia article](https://en.wikipedia.org/wiki/Lights_Out_(game)) for more info. Also, at the bottom of that article, there's a link to an online playable version of the game. (You can also Google for additional playable versions online.)

In this deep dive, you're going to make your own playable Lights Out game - in the terminal!

## Downloading the Exercise

To download the exercise, please fork this repository on Github, and then clone the repository to your computer.

This will create a folder on your computer which contains all the code files you'll need to proceed.

## Exercise Details

We've gotten you started with a `Game` class found inside the file `game.rb`. It contains a little bit of code already, but you're going to need to complete the rest of it.

In addition to this file, you'll also need to create a `runner.rb` file from scratch. In this file, you'll allow a user to interact with the game via the terminal. This is very similar to other "runner" files from previous deep dives. (See, for example, the runner file from Deep Dive 6: Book Report Generator.)

### Entering The Matrix

Go ahead and open the `game.rb` file. You'll see that the main data structure inside the `Game` class is a `@grid` containing an array. This array itself contains more arrays, which in turn hold a bunch of `0`s.

An array of arrays is also known as a *matrix*. While this data structure has a fancy name, it's nothing more than an array which contains other arrays. However, it can take some time to get used to working with a matrix.

It just so happens that one of our episodes of Think Like a Software Engineer introduces the matrix and the basics of working with one. This video should be pretty helpful for this exercise, so we [recommend watching it](https://anyonecanlearntocode.com/think-like-a-software-engineer/videos/74).

Each value in our `@grid` matrix represents a button. A `0` represents that the button's light is turned off, while a `1` means that the button's light is on.

When the game is initialized, our existing code creates a grid with all the lights turned off. However, you'll see that the constructor ends with a call to a method called `randomize_grid`, which will create a random setup, with some lights turned on, and others turned off. This method has not been completed yet; that's part of your job.

We also already created for you a `print_grid` method. This will print the existing `@grid` to the terminal. (To see this in action, you can add `Game.new.print_grid` at the end of the file and run the code.)

### Make The Game!

Your instructions are pretty straightforward: Take the barebones existing code, and extend it to make a playable game! This, again, will involve completing the `Game` class and also creating a "runner" file as mentioned above.

To make things just a tad easier, we created some empty methods in the `Game` class as suggestions for how to move forward.

One of these methods is the aforementioned `randomize_grid` method. This should take the `@grid` and randomize its values to some combination of `0`s and `1`s.

Another method is `choose_space`. This accepts the row and column numbers, and should change that button on the `@grid` accordingly. This is where some of the critical logic takes place: You'll need to toggle the chosen button, as well as all of its adjacent buttons. (Note that diagonal buttons are not considered adjacent in this game.)

We've also created a `won?` method. This method should analyze the `@grid` at a given moment, and return either `true` or `false` depending on whether the `@grid` is in a winning state. This happens when all of the lights are off.

And... the rest is up to you. The end goal is to have an actual playable game.

## Bonuses

There are tons of interesting features you can add to this game beyond what we've already described. Feel free to come up with your own ideas, but here are a few suggestions.

1. Make it so that the game can be played with grids of other sizes (e.g. 6 x 6, or 4 x 4).
2. Make a much nicer `print_grid` output. The output can certainly be prettier, and you can also add row and column numbers to make things easier on the player.
3. Have the game load specific preset puzzles (from a file), instead of completely random setups.

## Unit Tests

There are no unit tests - but that's another bonus opportunity! Create your own unit tests. 

While methods like `print_grid` are awfully hard to test, the `choose_space` and `won?` methods are certainly testable.

## Committing to Github

To commit your code to Github, you can run the following set of commands in the terminal:

```
git add --all
git commit -m "your commit message goes in between these quotation marks"
git push origin YOUR-GITHUB-USERNAME-GOES-HERE
```