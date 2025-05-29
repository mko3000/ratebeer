const BREWERIES = {};

const handleResponse = (breweries) => {
    BREWERIES.list = breweries;
    BREWERIES.show();
};

const createTableRow = (brewery) => {
    const tr = document.createElement("tr");
    tr.classList.add("tablerow");
    const breweryname = tr.appendChild(document.createElement("td"));
    breweryname.innerHTML = brewery.name;
    const breweryfounded = tr.appendChild(document.createElement("td"));
    breweryfounded.innerHTML = brewery.year;
    const beercount = tr.appendChild(document.createElement("td"));
    beercount.innerHTML = brewery.beers.length;
    const activestatus = tr.appendChild(document.createElement("td"));
    activestatus.innerHTML = brewery.active ? "Active" : "Inactive";

    return tr;
};

BREWERIES.show = () => {
    document.querySelectorAll(".tablerow").forEach((el) => el.remove());
    const table = document.getElementById("brewerytable");

    BREWERIES.list.forEach((brewery) => {
        const tr = createTableRow(brewery);
        table.appendChild(tr);
    });
};

BREWERIES.sortByName = () => {
    BREWERIES.list.sort((a, b) => {
        return a.name.toUpperCase().localeCompare(b.name.toUpperCase());
    });
};

BREWERIES.sortByFounded = () => {
    BREWERIES.list.sort((a, b) => {
        return a.year - b.year;
    });
};

BREWERIES.sortByBeercount = () => {
    BREWERIES.list.sort((a, b) => {
        return b.beers.length - a.beers.length;
    });
};

const breweries = () => {
    if (document.querySelectorAll("#brewerytable").length < 1) return;

    document.getElementById("name").addEventListener("click", (e) => {
        e.preventDefault;
        BREWERIES.sortByName();
        BREWERIES.show();
    });

    document.getElementById("founded").addEventListener("click", (e) => {
        e.preventDefault;
        BREWERIES.sortByFounded();
        BREWERIES.show();
    });

    document.getElementById("beercount").addEventListener("click", (e) => {
        e.preventDefault;
        BREWERIES.sortByBeercount();
        BREWERIES.show();
    });

    document.getElementById("activestatus").addEventListener("click", (e) => {
        e.preventDefault;
        BREWERIES.show();
    });

    fetch("breweries.json")
        .then((response) => response.json())
        .then(handleResponse);

};

export { breweries };