# Chess.me
A Chess App for the iPhone. Enjoy! <br/>
Note: This game supports **ALL** iPhone models
# Game Modes
**.me** - Play against a basic Chess "AI". More about the opponent, the Chess AI uses a Min-Max tree to find the "best" move and alpha-beta pruning for optimization. For board evalution it uses piece values and piece-square tables. As of now it looks four moves deep. <br/> <br/>
**.bluetooth** - Play with friends. Using Xcode's Multipeer Connectivity framework I implemented bluetooth Chess. Host a game session or join a friend's. <br/><br/>
**.couple** - Vanilla pass and play Chess, the optimal gamemode for when phones are running low on battery. 

# Deployment
1. > Clone the repo <br/>
2. > [In terminal] sudo gem install cocoapods <br/>
3. > [In terminal] Navigate to project folder; the one with the Chess.xcworkspace <br/>
4. > [In terminal] pod deintegrate <br/>
5. > [In terminal] pod install <br/>
6. > Launch Xcode <br/>
7. > Open Existing Project > Open Chess.xcworkspace <br/>
8. > [⌘ + SHIFT + K] or > Product > Clean <br/>
9. > [⌘ + R] or > Product > Run

# Goal
The goal of making this application has been to learn the basics of Swift and Xcode i.e. making custom views, creating UIs, using outlets, actions, etc. I want to learn Swift/Xcode because I want to be able to make apps, good apps, that people are willing to pay me to use. The great thing about software products like apps is that there is very little overhead so all I need to invest is time in order to produce a product that has the potential to make money. All in all, I want to start a business so I thought I mine as well start learning how to make and sell software. 
