/* ===========================================
   Auto Icon Button — convert <input type=submit/button>
   (dari asp:Button) jadi <button> dengan icon auto
   ikut text (Cari/Search, Set Semula/Reset, dsb)
   =========================================== */

function convertButtonsToIconButtons() {
    // senarai padanan: keyword dalam text -> icon class
    var iconMap = [
        { keywords: ['cari', 'search'], icon: 'bi bi-search' },
        { keywords: ['set semula', 'reset'], icon: 'bi bi-arrow-counterclockwise' },
        { keywords: ['simpan', 'save', 'kemaskini', 'kemas kini'], icon: 'bi bi-save' },
        { keywords: ['padam', 'delete', 'nyah aktif'], icon: 'bi bi-trash' },
        { keywords: ['kembali', 'back'], icon: 'bi bi-arrow-left' },
        { keywords: ['tambah', 'baharu', 'add', 'new'], icon: 'bi bi-plus-lg' },
        { keywords: ['muat naik', 'upload'], icon: 'bi bi-upload' },
        { keywords: ['muat turun', 'download'], icon: 'bi bi-download' },
        { keywords: ['hantar', 'submit'], icon: 'bi bi-send' },
        { keywords: ['batal', 'cancel'], icon: 'bi bi-x-lg' },
        { keywords: ['lihat', 'view'], icon: 'bi bi-eye' },
        { keywords: ['cetak', 'print'], icon: 'bi bi-printer' }
    ];

    function findIcon(text) {
        var lower = text.trim().toLowerCase();
        for (var i = 0; i < iconMap.length; i++) {
            for (var j = 0; j < iconMap[i].keywords.length; j++) {
                if (lower.indexOf(iconMap[i].keywords[j]) !== -1) {
                    return iconMap[i].icon;
                }
            }
        }
        return null; // takde padanan, biar text je tanpa icon
    }

    // cari semua input submit/button yang guna class .btn (asp:Button biasa)
    var inputs = document.querySelectorAll('input[type="submit"].btn, input[type="button"].btn');

    inputs.forEach(function (input) {
        // elak proses dua kali
        if (input.dataset.iconConverted === "1") return;

        var text = input.value || '';
        var iconClass = findIcon(text);

        // buat <button> baru, copy semua attribute dari input asal
        var btn = document.createElement('button');
        btn.type = input.type === 'submit' ? 'submit' : 'button';

        // copy semua attribute (id, name, class, onclick, style, dsb)
        Array.from(input.attributes).forEach(function (attr) {
            if (attr.name === 'value' || attr.name === 'type') return; // skip, handle manual
            btn.setAttribute(attr.name, attr.value);
        });

        // isi content button: icon SAHAJA (text asal dibuang)
        if (iconClass) {
            var icon = document.createElement('i');
            icon.className = iconClass;
            btn.appendChild(icon);
        } else {
            // takde padanan icon, kekalkan text asal supaya button tak kosong
            btn.appendChild(document.createTextNode(text));
        }

        // simpan text asal sebagai tooltip (title) supaya fungsi button tetap jelas
        if (!btn.getAttribute('title')) {
            btn.setAttribute('title', text.trim());
        }

        btn.dataset.iconConverted = "1";

        // gantikan input dengan button dalam DOM (postback tetap jalan
        // sebab name+value attribute sama, form submit behavior sama)
        input.parentNode.replaceChild(btn, input);
    });
}

document.addEventListener('DOMContentLoaded', convertButtonsToIconButtons);

// jalan semula lepas UpdatePanel partial postback (AJAX)
if (typeof Sys !== 'undefined' && Sys.WebForms && Sys.WebForms.PageRequestManager) {
    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(convertButtonsToIconButtons);
}