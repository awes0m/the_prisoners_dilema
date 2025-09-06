# the_prisoners_dilema


A comprehensive Prisoner's Dilemma game in Flutter with all the features you requested! Here's what the implementation includes:

## 🎮 **Key Features Implemented:**

### **Game Modes:**

* **User vs Computer** with 6 different AI strategies
* **User vs User** for local multiplayer
* Strategy selection screen with difficulty indicators

### **Visual Elements:**

* **Animated stick figures** that react to player choices
* Stick figures show cooperation (🤝) or defection (⚔️) symbols
* Smooth animations with elastic effects when actions are chosen
* Custom painted stick figures with color coding (blue/red)

### **Game Logic:**

* **Complete payoff matrix** implementation (3,3 / 5,0 / 0,5 / 1,1)
* **Win conditions** : First to 50 points or after 20 rounds
* Real-time score tracking and round history
* Game end screen with final results

### **AI Strategies (10 Total):**

1. **Tit for Tat** - Classic reciprocal strategy
2. **Always Cooperate** - Trusting angel
3. **Always Defect** - Exploitative devil
4. **Grudger** - Unforgiving punishment
5. **Random** - 50/50 probability
6. **Pavlov** - Win-stay, lose-shift
7. **Generous Tit for Tat** - Forgiving reciprocal
8. **Tit for Two Tats** - More patient retaliation
9. **Suspicious Tit for Tat** - Starts with defection
10. **Generous** - Mostly cooperative with testing

### **Strategy Encyclopedia:**

* **Comprehensive strategy guide** with expandable cards
* Each strategy includes:
  * Detailed description and behavior
  * Strengths and weaknesses analysis
  * Example gameplay sequences
* **Interactive payoff matrix** dialog
* Visual explanations of game theory concepts

### **State Management:**

* **Riverpod** for all game state management
* Reactive UI updates
* Persistent game history
* Clean separation of game logic and UI

### **Responsive Design:**

* Works on mobile and web
* Adaptive layouts
* Touch-friendly controls
* Scrollable history display

### **Advanced Features:**

* **Round history visualization** with action icons
* **Animated feedback** when actions are selected
* **Difficulty ratings** for AI strategies
* **Game reset functionality**
* **Navigation between all screens**

## 🚀 **To Use This Code:**

1. Create a new Flutter project
2. Add dependencies to `pubspec.yaml`:

yaml

```yaml
dependencies:
flutter_riverpod: ^2.4.0
```

3. Replace the main.dart content with this code
4. Run `flutter pub get`
5. Launch the app!

The game provides an excellent educational tool for understanding game theory concepts while being engaging and visually appealing. The AI strategies are based on real research from iterated prisoner's dilemma tournaments, making it both fun and academically valuable.
