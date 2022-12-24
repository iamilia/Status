let isHudInFull = true;
let isHudHide = true;
let data = {}

const foodBG = "rgb(141, 83, 13)";
const waterBG = "rgb(22, 94, 136)";
const healBG = "darkred";
const armorBG = "rgb(9, 55, 180)";

// Update clock in left side of HUD in big size
function updateClock() {
    const clock = $("#clock");

    let date = new Date();
    let hours = date.getHours().toString();
    let minutes = date.getMinutes().toString();

    if (minutes.length == 1) minutes = `0${minutes}`;

    clock.text(`${hours}:${minutes}`);
}

// Update items in short size
function updateMiniLine(miniLineID, amount, backgroundColor, state = true) {
    const name = miniLineID.split("-")[0];
    const marginBottomAmount = 100 - amount;

    const miniLine = $(`#${miniLineID}`);
    const background = $(`#imageHandler-${name}`);

    if (state) {
        miniLine.css("height", `${amount}%`);
        miniLine.css("margin-top", `${marginBottomAmount}%`);
        background.css("background-color", backgroundColor);
    } else {
        miniLine.css("height", "0px");
        background.css("background-color", "#475b75");
    }
}

// Update job icon (available on SWAT , PD , MD , Taxi )
//   You can change icon for this jobs in ./html/icons/
function updateJobIcon(jobName) {
    const jobIcon = $("#job-icon");

    if (jobName.toLowerCase() == "police")
        jobIcon.attr("src", "html/icons/police.png");
    if (jobName.toLowerCase() == "medic")
        jobIcon.attr("src", "html/icons/medic.png");
    if (jobName.toLowerCase() == "taxi")
        jobIcon.attr("src", "html/icons/taxi.png");
    if (jobName.toLowerCase() == "swat")
        jobIcon.attr("src", "html/icons/swat.png");
}

// For set items (heal, money and...)
function setHandler(event) {
    if (event.data.name && event.data.id) {
        $("#name").text(`${event.data.name} (${event.data.id})`);
        $("#userIcon-ID").text(event.data.id);
        data.id = event.data.id
        data.name = event.data.name
    }

    if (event.data.heal) {
        $("#heal").text(`${event.data.heal} %`);
        $("#heal-line").css("width", `${event.data.heal}%`);
        updateMiniLine("heal-mini-line", event.data.heal, "darkred");
        data.heal = event.data.heal
    }

    if (event.data.water) {
        updateMiniLine("water-mini-line", event.data.water, waterBG, false);
        data.water = event.data.water
    }

    if (event.data.food) {
        updateMiniLine("food-mini-line", event.data.food, foodBG, false);
        data.food = event.data.food
    }

    if (event.data.armor) {
        $("#armor").text(`${event.data.armor} %`);
        $("#armor-line").css("width", `${event.data.armor}%`);
        updateMiniLine("armor-mini-line", event.data.armor, "darkblue");
        data.armor = event.data.armor
    }

    if (event.data.cash) {
        $("#money").text(`${event.data.cash} $`);
        data.cash = event.data.cash
    }

    if (event.data.job && !event.data.job.name) {
        // Player have not job

        $("#job-item").css("display", "none");
    } else if (event.data.job && event.data.job.name && event.data.job.rank) {
        // Player have job
        $("#job-item").css("display", "flex");
        $("#job-name").text(event.data.job.name);
        $("#job-rank").text(event.data.job.rank);
        data.job = event.data.job
        updateJobIcon(event.data.job.name);
    }

    if (event.data.gang && !event.data.gang.name) {
        // Player have not gang
        $("#gang-item").css("display", "none");
    } else if (
        event.data.gang &&
        event.data.gang.name &&
        event.data.gang.rank
    ) {
        // Player have gang
        $("#gang-item").css("display", "flex");
        $("#gang-name").text(event.data.gang.name);
        $("#gang-rank").text(event.data.gang.rank);
        data.gang = event.data.gang
    }
}

// For change display mode of all hud between show and hide
function display(isHudHides) {
    const container = $("#container");

    if (isHudHides) {
        // ? If HUD is hide

        container.css("display", "block");
        setTimeout(() => {
            container.css("opacity", "1");
        }, 100);
        isHudHide = false;
    } else {
        // ? If HUD is not hide

        container.css("opacity", "0");
        isHudHide = true;
        setTimeout(() => {
            container.css("display", "none");
        }, 500);
    }
}

function animteShortToFull(event) {
    const leftSideItems = $("#leftSide-items");
    const mainItemsValue = $(".mainItems-value");
    const mainItemsUL = $("#mainItems");
    if (!event) {
        event.data = data
    }
    const userIcon = $("#userIcon");
    const userIconID = $("#userIcon-ID");

    const subWater = $("#mainItems-sub-water");
    const waterIcon = $("#imageHandler-water");

    leftSideItems.css("display", "block");
    setTimeout(() => {
        updateMiniLine("heal-mini-line", event.data.heal, healBG, false);
        updateMiniLine("armor-mini-line", event.data.armor, armorBG, false);
        updateMiniLine("water-mini-line", event.data.water, waterBG, false);
        updateMiniLine("food-mini-line", event.data.food, foodBG, false);

        userIconID.css("opacity", "0");
        setTimeout(() => {
            userIconID.css("display", "none");
            userIcon.css("display", "block");
            mainItemsValue.css("display", "block");
            setTimeout(() => {
                userIcon.css("opacity", 1);
                mainItemsUL.css("width", "350px");

                setTimeout(() => {
                    subWater.css("margin-top", "10px");
                    setTimeout(() => {
                        subWater.css("margin-top", "50px");
                        setTimeout(() => {
                            mainItemsValue.css("opacity", "1");
                            subWater.css("transition", "margin-top 0.4s ease-in-out");
                            setTimeout(() => {
                                subWater.css("margin-top", "0");
                                leftSideItems.css("height", "300px");
                                setTimeout(() => { }, 300);
                            }, 260);
                        }, 240);
                    }, 100);
                }, 238);
                waterIcon.css("right", "170px");
            }, 10);
        }, 300);
    }, 10);
}

// Display items in short size
function allAndShort(event) {
    if (!event) {
        event.data = data
    }
    const leftSideItems = $("#leftSide-items");
    const mainItemsValue = $(".mainItems-value");
    const mainItemsUL = $("#mainItems");

    const userIcon = $("#userIcon");
    const userIconID = $("#userIcon-ID");

    const subWater = $("#mainItems-sub-water");
    const waterIcon = $("#imageHandler-water");

    const healMiniLine = $("#heal-mini-line");
    const armorMiniLine = $("#armor-mini-line");
    const waterMiniLine = $("#water-mini-line");
    const foodMiniLine = $("#food-mini-line");

    subWater.css("margin-top", "70px");
    leftSideItems.css("height", "1px");
    setTimeout(() => {
        subWater.css("transition", "margin-top 0.01s ease-in-out");
        setTimeout(() => {
            subWater.css("margin-top", "10px");
        }, 238);
        waterIcon.css("right", "5px");

        mainItemsValue.css("opacity", "0");
        leftSideItems.css("display", "none");
        mainItemsUL.css("width", "3%");
        setTimeout(() => {
            mainItemsValue.css("display", "none");

            healMiniLine.css("display", "flex");
            armorMiniLine.css("display", "flex");
            waterMiniLine.css("display", "flex");
            foodMiniLine.css("display", "flex");

            userIcon.css("opacity", "0");
            updateMiniLine("heal-mini-line", event.data.heal, healBG);
            updateMiniLine("armor-mini-line", event.data.armor, armorBG);
            updateMiniLine("water-mini-line", event.data.water, waterBG);
            updateMiniLine("food-mini-line", event.data.food, foodBG);
            setTimeout(() => {
                userIconID.css("display", "block");
                userIcon.css("display", "none");
                setTimeout(() => {
                    userIconID.css("opacity", "1");
                }, 10);
            }, 300);
        }, 200);
    }, 600);

    isHudInFull = false;
}

function fullHandler(event) {
    if (!isHudInFull) {
        animteShortToFull(event);
        setTimeout(() => {
            allAndFull(event);
        }, 5000);
    } else {
        allAndFull(event);
    }
}

// Display items in full size
function allAndFull(event) {
    if (!event) {
        event.data = data
    }
    const leftSide = $("#leftSide-items");
    const itemsValue = $(".mainItems-value");

    const nameText = $("#name");
    const healText = $("#heal");
    const armorText = $("#armor");
    const cashText = $("#money");
    const waterText = $("#water");
    const foodText = $("#food");

    const heal = $("#heal-line");
    const armor = $("#armor-line");
    const water = $("#water-line");
    const food = $("#food-line");

    $("#userIcon-ID").text(event.data.id);

    nameText.text(`${event.data.name} ( ${event.data.id} )`);
    healText.text(`${event.data.heal} %`);
    armorText.text(`${event.data.armor} %`);
    cashText.text(`${event.data.cash} $`);
    waterText.text(`${event.data.water} %`);
    foodText.text(`${event.data.food} %`);

    itemsValue.css("opacity", "1");
    leftSide.css("display", "block");

    heal.css("width", `${event.data.heal}%`);
    armor.css("width", `${event.data.armor}%`);
    food.css("width", `${event.data.food}%`);
    water.css("width", `${event.data.water}%`);
    if (event.data.job) {
        if (event.data.job.name && event.data.job.rank) {
            const jobName = $("#job-name");
            const jobItem = $("#job-item");
            const jobRank = $("#job-rank");

            jobName.text(`${event.data.job.name}`);
            jobRank.text(`${event.data.job.rank}`);

            jobItem.css("display", "flex");
        }
    } else {
        $("#job-item").css("display", "none");
    }
    if (event.data.gang) {
        if (event.data.gang.name && event.data.gang.rank) {
            const gangName = $("#gang-name");
            const gangItem = $("#gang-item");
            const gangRank = $("#gang-rank");

            gangName.text(`${event.data.gang.name}`);
            gangRank.text(`${event.data.gang.rank}`);

            gangItem.css("display", "flex");
        }
    } else {
        const gangItem = $("#gang-item");
        gangItem.css("display", "none");
    }

    updateClock();
    setInterval(() => {
        updateClock();
    }, 1000);
}

// Check current size for items and new size and run correct function
function eventHandler(event) {
    if (event.type == "all" && event.size == "full") {
        fullHandler(event);
    } else if (event.type == "all" && event.size == "short") {
        allAndShort(event);
    } else if (event.type == "set") {
        setHandler(event);
    } else if (event.type == "display") {
        display(event.state);
    }
}

// Handle when a data comes from LUA side
// window.onload = function (e) {
window.addEventListener("message", (event) => {
    eventHandler(event.data);
});
  // }

