# Game "Guess the Number"

<p align="center">
  <img src="assets/screenshots/banner.png" width="600px" alt="Guess the Number Game Banner">
</p>

This project implements a cross-platform mobile game “Guess the Number,” where the system generates a random number, and the user has a limited number of attempts to guess it.

## Features

- Customizable range of generated numbers and attempts
- Automatic validation of user input
- Option to view hints
- Game history

## How to Play

- Enter the maximum generated number and the number of attempts.
- Click the "Start Game" button.
- The range of generated numbers and the number of remaining attempts will be displayed at the top of the screen.
- Try to guess the generated number by entering your answer in the "Your Guess" field and pressing the "Check" button.
- Checked numbers are displayed at the bottom of the screen (up to 100 numbers). You can tap on a checked number to set it in the "Your Guess" field for quick editing.
- When "hints" are enabled, checked numbers are highlighted in blue if the guess is lower than the generated number, and in red if higher. The closer your answer, the more clearly the number will be visible.
- If desired, you can enable or disable automatic generation of a random number for the "Your Guess" field after checking.
- If you guess the number, or run out of attempts, a popup window with the game result will appear. Press "Restart Game" to play again with the same parameters, or tap the back arrow or outside the popup to return to the menu.
- Each game session is recorded, and the result can be seen in the "History" section, which can be cleared. Matches where hints were used are displayed separately.

## Screenshots

<details><summary><b>Material Design</b></summary>
   <table>
   <tr>
      <th><img src="assets/screenshots/Screenshot-1.webp" alt="Main screen/menu"/></th>
      <th><img src="assets/screenshots/Screenshot-2.webp" alt="Game screen"/></th>
      <th><img src="assets/screenshots/Screenshot-3.webp" alt="Input field validation demo"/></th>
   </tr>
   <tr>
      <th><img src="assets/screenshots/Screenshot-4.webp" alt="Defeat"/></th>
      <th><img src="assets/screenshots/Screenshot-5.webp" alt="Victory"/></th>
      <th><img src="assets/screenshots/Screenshot-6.webp" alt="Main screen after completed match with hints"/></th>
   </tr>
   </table>
</details>
<details><summary><b>Cupertino</b></summary>
   <table>
   <tr>
      <th><img src="assets/screenshots/Screenshot-7.webp" alt="Main screen/menu"/></th>
      <th><img src="assets/screenshots/Screenshot-8.webp" alt="Game screen"/></th>
      <th><img src="assets/screenshots/Screenshot-9.webp" alt="Input field validation demo"/></th>
   </tr>
   <tr>
      <th><img src="assets/screenshots/Screenshot-10.webp" alt="Defeat"/></th>
      <th><img src="assets/screenshots/Screenshot-11.webp" alt="Victory"/></th>
      <th><img src="assets/screenshots/Screenshot-12.webp" alt="Main screen after completed match with hints"/></th>
   </tr>
   </table>
</details>
