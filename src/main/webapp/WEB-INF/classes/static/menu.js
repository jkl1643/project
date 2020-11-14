var x = 0;
var y = 0;
var maindiv = document.getElementById('main');
var menu = document.getElementById('menu');
var bottom = document.getElementById('bottom');
var userList = document.getElementById('userListMenu');

var selectVideo = document.getElementsByTagName('video');

var left_cam = document.getElementById('left_cam');
var selectCanvas = document.getElementById('canvas');
var userListMenu2 = false;
let totalNum = 0;
var left_cam_status = 0;
var selectVideo_status = 0;
var selectCanvas_status = 0;
var selectVideo_exist = 0;
var videoCount = 1;
console.log("selectvideo : " + selectVideo.length)

left_cam.addEventListener("mouseup",
    function (a) {
        if (left_cam_status == 0) {
            if (totalNum == 2) {
                left_cam_status = 1;
                videoGrid.style.gridTemplateColumns = "80% 20%";
            } else if (totalNum == 3) {
                left_cam_status = 1;
                videoGrid.style.gridTemplateColumns = "70% 15% 15%";
            } else if (totalNum == 4) {
                left_cam_status = 1;
                videoGrid.style.gridTemplateColumns = "60% 10% 10% 10%";
            }
        } else if (left_cam_status == 1) {
            if (totalNum == 2) {
                left_cam_status = 0;
                videoGrid.style.gridTemplateColumns = "50% 50%";
            } else if (totalNum == 3) {
                left_cam_status = 0;
                videoGrid.style.gridTemplateColumns = "33% 33% 33%";
            } else if (totalNum == 4) {
                left_cam_status = 0;
                videoGrid.style.gridTemplateColumns = "25% 25% 25% 25%";
            }
        }
    }
);

/*selectVideo[1].addEventListener("mouseup",
    function(b) {
    console.log("aaaaaaaaa");
    });*/
    /*selectVideo[1].addEventListener("mouseup",
        function (b) {
            console.log("aaaaaaaaa");
        });*/
/*selectVideo[2].addEventListener("mouseup",
    function(b) {
        console.log("aaaaaaaaa");
    });*/
//try {
    /*selectVideo.addEventListener("mouseup",
        function (a) {
            console.log("selectVideo_exist : " + selectVideo_exist);
            if (selectVideo_status == 0) {
                if (totalNum == 2) {
                    selectVideo_status = 1;
                    console.log("totalNum22 : " + totalNum);
                    videoGrid.style.gridTemplateColumns = "80% 20%";
                } else if (totalNum == 3) {
                    selectVideo_status = 1;
                    videoGrid.style.gridTemplateColumns = "70% 15% 15%";
                }
            } else if (selectVideo_status == 1) {
                if (totalNum == 2) {
                    selectVideo_status = 0;
                    videoGrid.style.gridTemplateColumns = "50% 50%";
                } else if (totalNum == 3) {
                    selectVideo_status = 0;
                    videoGrid.style.gridTemplateColumns = "33% 33% 33";
                }
            }
        }
    );*/
//} catch (e) {
    //console.log("에러");
//}

$(function(){
    $('.left_cam').resizable({
        minHeight : 50,
        minWidth:70,
        autoHide: true,
        ghost : true
    });
});













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