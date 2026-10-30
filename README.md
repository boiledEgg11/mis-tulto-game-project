# mis-tulto-game-project
## Description
A platformer game that I am currently making; its main feature is the “possess” feature which have been added since the second release (release 0.2.0 alpha) of the game. The main objective of this game is planned to go to a specific location while avoiding to get defeated by enemies. As of now, this game is currently mostly placeholders; the first stage and the ui is planned to be made soon. Until then, this game is simply a platformer with some simple enemies that only have movements, and no objectives.
## Why am I making this?
Well, making a game was my dream since I was about 3rd grade; ever since, I have been having ideas about it. So this game project is something that I have thought for years; now that I have a motivation and learned a way how to develop, I am making this game. Also made for Terra.
## How to play
The playable versions of the game is in the releases section! Please download the non-source code files, which contains the mis-tulto.exe in order to start playing the game. The version specific instructions are written below.
### For [release 0.1.0 alpha:](https://github.com/boiledEgg11/mis-tulto-game-project/releases/tag/Pre-releases)
This release is in a zip file unlike the other releases; this is due to the pck file not being embedded. Please extract the pck file and the mis-tulto.exe from the Mis-tulto.zip in order to play on the release.
### For [release 0.2.0 alpha](https://github.com/boiledEgg11/mis-tulto-game-project/releases/tag/Pre-release2) and onward:
Please download the mis-tulto.exe, which already has the pck file embedded in order to start playing the game. No extra files are needed in order to play the game. 
## Features / Changelog:
### Release 0.1.0 alpha:
A simple movement system with dashing/attacking, crouching, fast-falling, simple enemy, health
Controls: WASD, which W is for jump, D is for crouch. Down while mid-air makes falling faster. Space key while moving allows dashing in the given direction; while done so, dash gives invincibility and attack area.
The current tiles are all test tiles; the half blocks are sizes which crouch can go through, and the green ones are half collision tiles.
The red moving object is the test enemy; upon collision, it will cause the player to lose 1 health, and dashing it 2 times will defeat it.
Falling down will cause the player to lose half their health and return to the original location; this feature is later planned to be changed.
<img width="1919" height="1025" alt="Screenshot (42)" src="https://github.com/user-attachments/assets/f0aefed2-5928-4054-a102-2bae4f246a1e" />
Dashing
<img width="1920" height="1027" alt="Screenshot (50)" src="https://github.com/user-attachments/assets/ba651b4e-a9c2-4288-9d10-ca3d3aee3404" />
Getting hurt
<img width="1920" height="996" alt="スクリーンショット 2026-10-30 062851" src="https://github.com/user-attachments/assets/f929c66c-cce7-4e39-8c2f-d8d5a6a793cc" />
Crouching
<img width="1920" height="1007" alt="スクリーンショット 2026-10-30 062225" src="https://github.com/user-attachments/assets/a91f9b99-60fc-44ba-ac7e-d395eb1fd97a" />
Idle
### Release 0.2.0 alpha
**Made possess system**<br>
Now, the dash will deplete the *possess health* instead of the normal health. *The previous dash can still be done by dashing into the ground.* Once the dash depletes the enemy's possess health to 0, the player can possess the enemy. While doing so, the player will gain the enemy's appearance and the abilities; the status, too. For example, the orange enemy that appears in the game is a medium-speed moving enemy that attacks the player with a charge attack. Upon possessing the enemy, the player becomes the orange enemy, which can perform charge attacks to break the cyan blocks and defeat enemies.<br>
**Other Features**<br>
Expanded the map; now, there are platforms below the starting point, and to the far right, which is blocked by cyan blocks; these can be destroyed via the usage of the orange enemy's possess ability.<br>
Added enemies; the green enemy is an enemy that hops around. Upon possession, the player will hop around, too and can perform a superjump when the blue bar below health bar is full. The cyan enemy is a floating enemy; it floats around, and upon possession the player will do so too, except the player can use an ability to shoot projectiles with a charge. The orange enemy is an enemy that finds the player and does a charge attack. This will deplete half of the player's health! The same action can be done while possessing; the attacks will defeat the enemies and destroy cyan tiles.<br>
*Tweaks*<br>
Added indication of what abilities are usable currently.
<img width="1920" height="1012" alt="Screenshot (51)" src="https://github.com/user-attachments/assets/6a3201e9-e405-4d66-af99-8fdbb92fd57f" />
Shooting with cyan enemy possess
<img width="1920" height="1022" alt="Screenshot (57)" src="https://github.com/user-attachments/assets/27bb86c9-4801-46cf-9f96-d367bbf85d31" />
Jumping with green enemy possess
<img width="1920" height="1008" alt="Screenshot (55)" src="https://github.com/user-attachments/assets/7a938a87-053e-49d1-ab8c-cb8f70f3ca6c" />
Exploring the expanded area
<img width="1920" height="1019" alt="Screenshot (54)" src="https://github.com/user-attachments/assets/cf816ec6-162e-4c15-86da-9d11e3c70aa9" />
Exploring the expanded area after falling
<img width="1920" height="1032" alt="Screenshot (53)" src="https://github.com/user-attachments/assets/70a0b403-9539-41cc-812b-f8a1793f8b01" />
Destryoing cyan tiles
<img width="1920" height="1036" alt="Screenshot (52)" src="https://github.com/user-attachments/assets/106b1bdb-df0f-4804-95e2-6b18dc7c1ad4" />
Moving away from the charging orange enemy
