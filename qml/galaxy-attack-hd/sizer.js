//Abstracts the sizes of each item depending on the screen size

function alien1width()
{
    return board.width * 0.05;
}

function alien2width()
{
    return board.width * 0.05;

}

function alien3width()
{
    return board.width * 0.05;
}

function mysteryWidth()
{
    if (board.width >= 800) {
        return 16*5;
    } else {
        return 16*4;
    }

}

function mysteryHeight()
{
    if (board.width >= 800) {
        return 9*4;
    } else {
        return 9*3;
    }
}

function alienXGap()
{
    return board.width * 0.005;
}

function alienYGap()
{
    return board.height * 0.005;
}

function bunkerWidth()
{
    return (15 * (board.width * 0.00625));
}

function bunkerHeight()
{
    return (15 * (board.width * 0.005));
}

function bunkerY()
{
   return board.height - (ship.height * 2) - bunkerHeight() - 5;
}

function bunkerX(n)
{
    var gap = Math.floor((board.width - (bunkerWidth() * 4)) / 5);
    return ((n - 1) * (bunkerWidth() + gap)) + gap;
}

function bombSpeed()
{
    return board.width * 0.0125;
}

function laserSpeed()
{
    return board.width * 0.03;
}

function largeFontSize()
{
    //console.log("Large font size is ", board.width * 0.04)
    return board.width * 0.04;
    //return Helper.mmToPixels(6);
}

function smallFontSize()
{
    return board.width * 0.02;
    //return Helper.mmToPixels(4);

}
