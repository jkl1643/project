var x = 0;
var y = 0;
var maindiv = document.getElementById('main');
var menu = document.getElementById('menu');
var bottom = document.getElementById('bottom');
var userList = document.getElementById('userListMenu');
var userListMenu2 = false;

maindiv.addEventListener("mousemove",
    function (a) {
        //menu.style.display = "inline";
        $('.menu').slideDown(200);
        $('.bottom').slideDown(200);
        mouseCoordinate(a);
        /*menu.addEventListener("mouseover",
            function () {
                menu.style.display = "inline";
            }
        ) */
    }
)

var x1 = 0;
var y1 = 0;
function mouseCoordinate(e) {


    /*maindiv.addEventListener("mouseover",
        function () {
            menu.style.display = "inline";
            x1 = 3;
            y1 = 3;
        }
    )*/


    menu.addEventListener("mouseover",
        function () {
            menu.style.display = "inline";
            x1 = 1;
            y1 = 1;
        }
    )

    menu.addEventListener("mouseout",
        function () {
            x1 = 0;
            y1 = 0;
        }
    )

    bottom.addEventListener("mouseover",
        function () {
            menu.style.display = "inline";
            x1 = 1;
            y1 = 1;
        }
    )

    bottom.addEventListener("mouseout",
        function () {
            x1 = 0;
            y1 = 0;
        }
    )

    x = e.clientX;
    y = e.clientY;



    setTimeout(function () {
        //var coor = "좌표 : ( " + x + ", " + y + ")" + ",( " + e.clientX + ", " + e.clientY + ")" + ",( " + x1 + ", " + y1 + ")";
        //console.log(coor);
        //document.getElementById("txt").innerHTML = coor;
        if (x1 == 0 && y1 == 0) {
            if (e.clientX == x && e.clientY == y) {
                //menu.style.display = "none";
                $('.menu').slideUp(200);
                $('.bottom').slideUp(200);
            }
        }
    }, 2000)
}

function userListOpen() {
    if (userListMenu2 === false) {
        userList.style.display = "inline";
        userListMenu2 = true;
    } else if (userListMenu2 === true) {
        userList.style.display = "none";
        userListMenu2 = false;
    }
}