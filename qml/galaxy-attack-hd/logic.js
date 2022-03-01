
var direction = 0;
var component;
var bullet = null;

var mysteryShip = null;
var mysteryShipDeployedThisLevel = false;

var aliendirection = 1;

var aliens = new Array(10*5);

var bombs = new Array(10); //Max of 10 bombs on screen at one time
var score = 0;
var dropBombChance = 100; //start chance of and alien dropping a bomb
var alienStartSpeed = 600; //the speed the aliens move at teh start of the level
var alienMaxSpeed = 50; //the maximum speed
var alienSpeedRatio = 0.85 //The speed increase on the next level

var level = 0;
var startlives = 3; //Edit this to cheat!
var livesindication = new Array();
var lives;

function cmdNotRunning() {
    gameState = "NOTRUNNING";
    level = 0;

    bunker1.demolish();
    bunker2.demolish();
    bunker3.demolish();
    bunker4.demolish();

    starttext.visible = true;
    infoImage.visible = true;
    startImage.visible = true;

    //Stop the animation timers
    heartbeat.running = false;
    alienanimation.running = false;


    startAnimation.start();
}

function cmdNewGame() {
    console.log("cmdNewgame");
    gameState = "NEWGAME";

    //Reset the score
    score = 0;
    scoretext.text = "Score: " + score;

    //Reset the level
    level = 0;

    //Reset the alien speed and chance of dropping a bomb
    alienStartSpeed = 600;
    dropBombChance = 100;

    lives = startlives;
    createLivesIndication();

    //Hide the logos
    starttimer.stop();
    startAnimation.stop();
    spacelogo.state = "HIDDEN";
    invaderslogo.state = "HIDDEN";
    hdlogo.state = "HIDDEN"
    infoImage.visible = false;
    startImage.visible = false;

    cmdStartNewLevel();
}

function cmdRunning() {
    gameState = "RUNNING";

    hideAllPanels();

    //Start the animation timers
    heartbeat.running = true;
    alienanimation.running = true;

    if (PlatformID != 5) {
        accelerometer.start();
    }
    
    direction = 0;
    
    ship.reset();
}

function hideAllPanels()
{
    //Hide all panels
    settingspanel.onScreen = false;
    hiscorepanel.onScreen = false;
    menupanel.onScreen = false

    if (PlatformID === 7){
        scoreloopBoard.onScreen = false;
    }
}

function cmdLifeLost() {
    gameState = "LIFELOST";
    lives--;
    if (livesindication[lives - 1]) {
        livesindication[lives - 1].destroy();
        livesindication[lives - 1] = null
    }
    powerMessage.displayMessage("Life Lost");

    //Stop the animation timers
    alienanimation.running = false;

}

function cmdDead() {
    gameState = "DEAD"

    //Stop the animation timers
    alienanimation.running = false;

    destroyAliens();
    cleanupBombs();
    bunker1.demolish();
    bunker2.demolish();
    bunker3.demolish();
    bunker4.demolish();

    powerMessage.displayMessage("GAME OVER");

    board.addNewScore(level, score);

    deadtimer.restart();
}

function cmdResume() {
    cmdRunning();
}

function cmdLevelComplete() {
    gameState = "LEVELCOMPLETE";

    powerMessage.displayMessage("Level " + level + " complete");

    //Remove the bunkers
    bunker1.demolish();
    bunker2.demolish();
    bunker3.demolish();
    bunker4.demolish();

    starttext.visible = true;

    heartbeat.running = false;
    alienanimation.running = false;

    cleanupBombs();

    if (alienStartSpeed > alienMaxSpeed) {
        alienStartSpeed = Math.floor(alienStartSpeed * alienSpeedRatio)
    }

    if (dropBombChance > 20) {
        dropBombChance -= 10; //drop more bombs!
    }

    if (level >= 3 && !optFullGameBought) {
        cmdNotRunning()
        buyDialog.onScreen = true;
    }

    //New Life every 10 levels
    if (((level % 5) == 0) && (lives < 8)) {
        lives++;
        createLivesIndication();
        powerMessage.displayMessage("Extra Life Gained!");
    }
}

function cmdStartNewLevel() {
    gameState = "LEVELSTARTING";

    level++;
    leveltext.text = "Level: " + level;

    bunker1.build();
    bunker2.build();
    bunker3.build();
    bunker4.build();

    mysteryShipDeployedThisLevel = false;

    starttext.visible = false;
    createAliens();

    //Set the alien speed at the start of the level
    alienanimation.interval = alienStartSpeed;

    if (PlatformID != 5) {
        accelerometer.start();
    }
    
    direction = 0;
    
    cmdRunning();
}

function cmdPause() {
    console.log("pause");
    gameState = "PAUSED";
    powerMessage.displayMessage("Paused");

    //Stop the animation timers
    heartbeat.running = false;
    alienanimation.running = false;
}

function screenTap() {
    if (infoMessage.onScreen || exitDialog.onScreen) {
        return;
    }

    if (settingspanel.onScreen || hiscorepanel.onScreen || menupanel.onScreen) {
        hideAllPanels();
        return;
    }

    if (PlatformID === 7) {
        if (scoreloopBoard.onScreen) {
            hideAllPanels();
            return;
        }
    }

    if (gameState == "NOTRUNNING") {
        cmdNewGame();
    } else if (gameState == "LIFELOST" || gameState == "PAUSED") {
        cmdResume();
    } else if (gameState == "LEVELCOMPLETE") {
        cmdStartNewLevel();
    } else if (gameState == "RUNNING") {
        fire();
    }
}

function createLivesIndication() {
    destroyLivesIndication();
    livesindication = new Array(lives - 1);
    var px = 0;
    var py = 0;

    py = board.height - ship.height;

    for (var i = 0; i < lives-1; ++i) {
        px = i * (ship.width + 20);

        var component = Qt.createComponent("Ship.qml");
        livesindication[i] = component.createObject(board);

        if ( livesindication[i] == null) {
            // Error Handling
            console.log("Error creating life ship");
        }
        if (livesindication[i]) {
            livesindication[i].x = px;
            livesindication[i].y = py;
        }

    }
}

function destroyLivesIndication() {
    for (var i = 0; i < lives-1; ++i) {
        if(livesindication[i]) {
            livesindication[i].destroy();
            livesindication[i] = null;
        }
    }
}

function shipHit() {
    ship.visible = false;

    playSound("explosion");

    ship.explode();

    cleanupBombs()
    if (mysteryShip != null){
        mysteryShip.destroy();
        mysteryShip = null;
    }

    if (lives > 1) {
        cmdLifeLost();
    } else { //game over
        cmdDead();
    }
}

//Load the bullet QML and position it at the centre of the ship
function createBullet() {
    //If there is no bullet, create one
    if (bullet == null ) {
        component = Qt.createComponent("bullet.qml");

        bullet = component.createObject(board);

        if ( bullet == null) {
            // Error Handling
            console.log("Error creating object");
        }
        if (bullet) {
            bullet.x = ship.x + ship.width/2 - bullet.width/2;
            bullet.y = ship.y;
            bullet.height = (Sizer.laserSpeed() < 20 ? 20 : Sizer.laserSpeed());
        }
    }
}

//Create all aliens and position them on the board in rows
function createAliens() {
    //Row 1
    component = Qt.createComponent("alien1.qml");
    var y = topline.y + topline.height + Sizer.alienYGap();
    for (var i=0; i<10; i++) {
        aliens[i] = component.createObject(board);
        aliens[i].x = ((aliens[i].width + Sizer.alienXGap()) * i) + Sizer.alienXGap();
        aliens[i].y = y;
        aliens[i].objectName = "alien_" + i;
    }

    //Row 2
    component = Qt.createComponent("alien2.qml");
    y += aliens[9].height + Sizer.alienYGap();
    for (i=0; i<10; i++) {
        aliens[i+10] = component.createObject(board);
        aliens[i+10].x = ((aliens[i+10].width + Sizer.alienXGap()) * i) + Sizer.alienXGap();
        aliens[i+10].y = y;
        aliens[i+10].objectName = "alien_" + i+10;
    }

    //Row 3
    y += aliens[19].height + Sizer.alienYGap();
    for (i=0; i<10; i++) {
        aliens[i+20] = component.createObject(board);
        aliens[i+20].x = ((aliens[i+20].width + Sizer.alienXGap()) * i) + Sizer.alienXGap();
        aliens[i+20].y = y;
        aliens[i+20].objectName = "alien_" + i+20;
    }

    //Row 4
    component = Qt.createComponent("alien3.qml");
    y += aliens[29].height + Sizer.alienYGap();
    for (i=0; i<10; i++) {
        aliens[i+30] = component.createObject(board);
        aliens[i+30].x = ((aliens[i+30].width + Sizer.alienXGap()) * i) + Sizer.alienXGap();
        aliens[i+30].y = y;
        aliens[i+30].objectName = "alien_" + i+30;

    }

    //Row 5
    y += aliens[39].height + Sizer.alienYGap();
    for (i=0; i<10; i++) {
        aliens[i+40] = component.createObject(board);
        aliens[i+40].x = ((aliens[i+40].width + Sizer.alienXGap()) * i) + Sizer.alienXGap();
        aliens[i+40].y = y;
        aliens[i+40].objectName = "alien_" + i+40;
    }
}

function rand(n)
{
    return (Math.floor(Math.random() * n));
}

function scheduleDirection(dir)
{
    direction = dir;
}

function fire()
{
    if (bullet == null) {
        createBullet()
    }

    //If the exisiting bullet is not off screen do nothing
    if (bullet.y > -10) {
        return;
    } else { //Reset bullet position
        if (optFlashOnFire) {
            flashanim.start();
        }

        playSound("shoot");

        bullet.x = ship.x + ship.width/2 - bullet.width/2;
        bullet.y = ship.y + ship.height - bullet.height;
        bullet.height = (Sizer.laserSpeed() < 20 ? 20 : Sizer.laserSpeed());
    }
}

function mainEvent() {
    if (gameState == "RUNNING") {
        //console.log(new Date().toISOString());
        move();
        moveBombs();
        moveBullet();
        mysteryShipHandling();
        checkCollisions();
        checkComplete();
        checkGameOver();
        //console.log(new Date().toISOString());
    }
}

function checkGameOver()
{
    //See if any aliens are past the 'invade' line
    for (var i = 0; i < 50; ++i) {
        if (aliens[i]) {
            if (aliens[i].y + aliens[i].height >= invadeline.y) {
                cmdDead();
                break
            }
        }
    }
}

function moveBombs() {
    for (var i = 0; i < 10; ++i) {
        if (bombs[i]) {
            if (bombs[i].y  < board.height + 40) {
                bombs[i].y += Sizer.bombSpeed();
            } else {
                bombs[i].destroy();
                bombs[i] = null;
            }
        }
    }
}

function moveBullet() {
    if (bullet) {
        if (bullet.y > -bullet.height){
            bullet.y -= Sizer.laserSpeed();
        }
    }
}

function checkComplete() {
    if (gameState == "RUNNING") {
        var count = 0;
        for (var i=0; i<50; i++) {
            if(aliens[i] != null) {
                count++;
            }
        }

        if(count == 0) {
            //Complete!
            cmdLevelComplete();
        }
    }
}

function checkCollisions()
{
    checkBulletAlienCollision();
    checkBombShipCollision();
    checkBombBunkerCollision();
    checkBulletBunkerCollision();
    checkBulletMysteryCollision();
    checkAlienBunkerCollision();
}

function checkBulletAlienCollision()
{
    //Loop over each alien, checking if the bullet intersects

    for (var i=0; i<50; i++) {
        if (bullet && aliens[i]) { //Check if objects exist first
            if (bullet.x > aliens[i].x && bullet.x < aliens[i].x + aliens[i].width) {
                if ((bullet.y > aliens[i].y  || bullet.y + bullet.height > aliens[i].y) && bullet.y < aliens[i].y + aliens[i].height) {
                    playSound("killed");

                    score += aliens[i].pointsAwarded;
                    scoretext.text = "Score: " + score;
                    bullet.y = -bullet.height; //Move the bullet offscreen

                    aliens[i].explode();
                    aliens[i] = null;
                    
                    if (alienanimation.interval > 100) { //Get faster when a alien is killed
                        alienanimation.interval -= 10;
                    }
                    break;
                }
            }
        }
    }
}

function checkBulletAlienCollisionNew()
{
    var collidingItems = Helper.collidingItems(bullet, board, "alien");

    if (collidingItems !== undefined && collidingItems.length > 0) {

        playSound("killed");

        score += collidingItems[0].pointsAwarded;
        scoretext.text = "Score: " + score;
        bullet.y = -bullet.height; //Move the bullet offscreen

        var idx = aliens.indexOf(collidingItems[0]);
        if (idx >= 0) {
            aliens[idx].explode();
            aliens[idx] = null;
        }

        if (alienanimation.interval > 100) { //Get faster when a alien is killed
            alienanimation.interval -= 10;
        }

    }
}

function checkAlienBunkerCollision()
{
    //Loop over each alien checking if it has hit the bunker
    for (var i=0; i<50; i++) {
        if (aliens[i] != null) { //Check if bomb object exist first
            var x = aliens[i].x;
            var y = aliens[i].y;
            var w = aliens[i].width;
            var h = aliens[i].height;

            if (x >= bunker1.x - w && x <= bunker1.x + bunker1.width && ((y + h) >= bunker1.y)){
                if (bunker1.checkCollision(x, y, w, h, true)) {
                    continue;
                }
            }

            if (x >= bunker2.x - w && x <= bunker2.x + bunker2.width && ((y + h) >= bunker2.y)){
                if (bunker2.checkCollision(x, y, w, h, true)) {
                    continue;
                }
            }

            if (x >= bunker3.x - w && x <= bunker3.x + bunker3.width && ((y + h) >= bunker2.y)){
                if (bunker3.checkCollision(x, y, w, h, true)) {
                    continue;
                }
            }

            if (x >= bunker4.x - w && x <= bunker4.x + bunker4.width && ((y + h) >= bunker2.y)){
                if (bunker4.checkCollision(x, y, w, h, true)) {
                    continue;
                }
            }
        }
    }
}


function checkBulletMysteryCollision()
{
    if (bullet && mysteryShip) {
        if (bullet.x > mysteryShip.x && bullet.x < mysteryShip.x + mysteryShip.width) {
            if (bullet.y > mysteryShip.y && bullet.y < mysteryShip.y + mysteryShip.height) {
                playSound("killed");

                score += mysteryShip.pointsAwarded;
                scoretext.text = "Score: " + score;
                bullet.y = -bullet.height; //Move the bullet offscreen

                mysteryShip.visible = false;

                mysteryShip.explode()
            }
        }
    }
}

function checkBombShipCollision() {
    //Loop over each bomb checking if it has hit the ship
    for (var i=0; i<10; i++) {
        if (bombs[i]) { //Check if bomb object exist first
            if (bombs[i].x > ship.x && bombs[i].x < ship.x + ship.width) {
                if (bombs[i].y > ship.y && bombs[i].y < ship.y + ship.height) {
                    bombs[i].destroy();
                    bombs[i] = null;
                    shipHit();
                    break;
                }
            }
        }
    }
}

function checkBombShipCollisionNew()
{
    var collidingItems = Helper.collidingItems(ship, board, "bomb");

    if (collidingItems !== undefined) {
        if (collidingItems.length > 0) {
            for (var i = 0; i < collidingItems.length; ++i) {
                collidingItems[i].destroy();
            }

            shipHit();
        }
    }
}

function checkBombBunkerCollision() {
    //Loop over each bomb checking if it has hit the ship
    for (var i=0; i<10; i++) {
        if (bombs[i]) { //Check if bomb object exist first
            var x = bombs[i].x;
            var y = bombs[i].y;
            var w = bombs[i].width;
            var h = bombs[i].height;

            if (x >= bunker1.x - w && x <= bunker1.x + bunker1.width){
                if (bunker1.checkCollision(x, y, w, h)) {
                    bombs[i].destroy();
                    bombs[i] = null;
                    continue;
                }
            }

            if (x >= bunker2.x - w && x <= bunker2.x + bunker2.width){
                if (bunker2.checkCollision(x, y, w, h)) {
                    bombs[i].destroy();
                    bombs[i] = null;
                    continue;
                }
            }

            if (x >= bunker3.x - w && x <= bunker3.x + bunker3.width){
                if (bunker3.checkCollision(x, y, w, h)) {
                    bombs[i].destroy();
                    bombs[i] = null;
                    continue;
                }
            }

            if (x >= bunker4.x - w && x <= bunker4.x + bunker4.width){
                if (bunker4.checkCollision(x, y, w, h)) {
                    bombs[i].destroy();
                    bombs[i] = null;
                    continue;
                }
            }
        }
    }
}

function checkBulletBunkerCollision() {
    if (bullet) { //Check if bomb object exist first
        var x = bullet.x;
        var y = bullet.y;
        var w = bullet.width;
        var h = bullet.height;

        if (bunker1.checkCollisionRev(x, y, w, h)) {
            bullet.y = -bullet.height;
        }
        else if (bunker2.checkCollisionRev(x, y, w, h)) {
            bullet.y = -bullet.height;
        }
        else if (bunker3.checkCollisionRev(x, y, w ,h)) {
            bullet.y = -bullet.height;
        }
        else if (bunker4.checkCollisionRev(x, y, w, h)) {
            bullet.y = -bullet.height;
        }
    }

}

function moveAliens() {

    var i = 0;
    var j = 0;

    //Find out if the direction needs changed
    if (aliendirection == 1) {
        for (i=0; i<50; i++) {
            if (aliens[i] != null) {
                if (aliens[i].x + aliens[i].width > board.width - 10) {
                    aliendirection = -1;

                    //Drop
                    for (j = 0; j<50; j++) {
                        if (aliens[j]) {
                            aliens[j].y += Sizer.alienYGap() * 3
                        }
                    }
                    break;
                }
            }
        }
    } else {
        for (i=0; i<50; i++) {
            if (aliens[i] !== null) {
                if (aliens[i].x < 10) {
                    aliendirection = 1;

                    //Drop
                    for (j=0; j<50; j++) {
                        if (aliens[j]) {
                            aliens[j].y +=  Sizer.alienYGap() * 3
                        }
                    }
                    break;

                }
            }
        }
    }

    //Move the aliens
    for (i=0; i<50; i++) {
        if (aliens[i] != null) {

            aliens[i].x += 10 * aliendirection;

            //Change the state to the other frame
            if (aliens[i].state === "FRAME0") {
                aliens[i].state = "FRAME1";
            } else {
                aliens[i].state = "FRAME0";
            }
        }
    }

    dropBomb();

}

function dropBomb() {

    for (var i = 0; i < 50; ++i) {
        if (aliens[i] != null) {
            var chance = rand(dropBombChance);
            if (chance === 1) {
                var slot = -1;

                //Check if there is space to store the bomb
                for (var j=0; j<10; j++) {
                    if (!bombs[j]) {
                        slot = j;
                        break;
                    }
                }

                if (slot >= 0) {
                    component = Qt.createComponent("bomb.qml");

                    var bomb = component.createObject(board);

                    if ( bomb == null) {
                        // Error Handling
                        console.log("Error creating bomb");
                    }
                    if (bomb) {
                        bomb.x = aliens[i].x + aliens[i].width/2 - bomb.width/2;
                        bomb.y = aliens[i].y + aliens[i].height;
                        bomb.objectName = "bomb_" + slot
                        bombs[slot] = bomb;

                    }

                }
            }
        }
    }
}

function cleanupBombs() {
    for (var i=0; i<10; i++) {
        if (bombs[i] !== undefined && bombs[i] != null ) {
            bombs[i].destroy();
            bombs[i] = null;
        }
    }
}

function destroyAliens() {
    for (var i=0; i<50; i++) {
        if (aliens[i] != null){
            aliens[i].destroy();
            aliens[i] = null;
        }
    }
}

function move() {
    if ((direction < 0 && ship.x > (direction * -1)) || (direction > 0 && (ship.x + ship.width + direction < board.width))) {
        ship.x += direction;
    }
}

function mysteryShipHandling()
{
    //Check if there is already a mystery ship, and if so move it
    //If there is no ship, decide whether or not to create one
    if (mysteryShip == null) {
        if (shouldDeployMysteryShip() === true) {
            mysteryShipDeployedThisLevel = true;
            component = Qt.createComponent("mystery.qml");

            mysteryShip = component.createObject(board);
            mysteryShip.x = board.width + 10;
            mysteryShip.y = topline.y + 5;

            playSound("mystery")
        }
    } else {
      if (!mysteryShip.visible) {
        mysteryShip.destroy();
        mysteryShip = null;
      } else {
        if (mysteryShip.x > (0 - Sizer.mysteryWidth())) {
            mysteryShip.x -= 10;
        } else {
            mysteryShip.destroy();
            mysteryShip = null;
        }
      }
    }
}

function shouldDeployMysteryShip()
{
    //Check if already deplyed this level
    if (mysteryShipDeployedThisLevel == true) {
        return false;
    }

    //Check if there is space to deploy
    var enoughSpace = true;

    for (var i = 0; i < 10; ++i) {
        if (aliens[i] !== null && aliens[i] !== undefined) {
            if (aliens[i].y < (Sizer.mysteryHeight() + topline.y + 5)) {
                enoughSpace = false;
            }
        }
    }

    if (enoughSpace == false) {
        return false;
    } else {
        if (rand(40) === 1){
            return true;
        }
    }
    return false;
}

//Multi platform function for playing sounds
function playSound(name)
{

    if (optSFX && PlatformID !== 5){
        if (PlatformID === 4 || PlatformID === 6 || PlatformID === 7) { //ANDROID/Playbook/Blackberry
            NativeAudio.playSound(name, false);
        } else {
            if (name === "killed") {
                destroyAlienSound.play();
            } else if (name === "shoot") {
                shootSound.play();
            } else if  (name === "explosion") {
                destroyShipSound.play();
            } else if (name === "mystery") {
                mysteryShipSound.play();
            }
        }
    }

}

