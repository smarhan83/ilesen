<%@ Page Language="VB" AutoEventWireup="false" CodeFile="CetakQRBanting.aspx.vb" Inherits="CetakQRBanting" %>

<!DOCTYPE html>
<html lang="ms">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Cetak QR Sepanduk / Bunting</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" />
    <style>
        * { box-sizing: border-box; }
        body { margin: 0; background: #f1f3f5; font-family: "Segoe UI", Arial, sans-serif; color: #212529; }

        /* ---------- Bar alat (tidak dicetak) ---------- */
        .qr-toolbar {
            position: sticky; top: 0; z-index: 10;
            display: flex; flex-wrap: wrap; gap: 12px; align-items: center; justify-content: space-between;
            padding: 14px 20px; background: #fff; border-bottom: 1px solid #e9ecef;
        }
        .qr-toolbar h1 { font-size: 16px; margin: 0; font-weight: 700; }
        .qr-toolbar p { margin: 2px 0 0; font-size: 13px; color: #6c757d; }
        .qr-toolbar .btns { display: flex; gap: 8px; }
        .btn {
            display: inline-flex; align-items: center; gap: 8px; border-radius: 8px; padding: 9px 16px;
            font-size: 14px; font-weight: 600; cursor: pointer; border: 1px solid #d0d5dd; background: #fff; color: #344054; text-decoration: none;
        }
        .btn-primary { background: #2E3192; border-color: #2E3192; color: #fff; }

        /* ---------- Helaian A4 ---------- */
        .sheet {
            width: 210mm; min-height: 297mm; margin: 20px auto; padding: 10mm; background: #fff;
            box-shadow: 0 2px 12px rgba(16,24,40,.08);
            display: grid; grid-template-columns: 1fr 1fr; gap: 6mm; align-content: start;
        }

        /* ---------- Label ---------- */
        .label {
            border: 1.5px dashed #adb5bd; border-radius: 4mm; padding: 5mm;
            display: flex; flex-direction: column; align-items: center; text-align: center;
            break-inside: avoid; page-break-inside: avoid;
        }
        .label-head { display: flex; align-items: center; gap: 3mm; width: 100%; padding-bottom: 3mm; border-bottom: 1px solid #e9ecef; }
        .label-head img { height: 11mm; }
        .label-head .org { text-align: left; line-height: 1.25; }
        .label-head .org b { display: block; font-size: 10pt; color: #2E3192; }
        .label-head .org span { font-size: 8pt; color: #6c757d; text-transform: uppercase; letter-spacing: .04em; }
        .label .qr { width: 48mm; height: 48mm; margin: 4mm 0 2mm; image-rendering: pixelated; }
        .label .kod { font-family: Consolas, "Courier New", monospace; font-size: 10pt; font-weight: 700; letter-spacing: .03em; }
        .label .lokasi-no { margin-top: 3mm; font-size: 8pt; font-weight: 700; color: #6c757d; text-transform: uppercase; letter-spacing: .05em; }
        .label .lokasi { font-size: 11pt; font-weight: 700; }
        .label dl { width: 100%; margin: 3mm 0 0; padding-top: 3mm; border-top: 1px solid #e9ecef; font-size: 8.5pt; text-align: left; }
        .label dl div { display: flex; gap: 2mm; padding: .6mm 0; }
        .label dt { flex: 0 0 22mm; color: #6c757d; }
        .label dd { margin: 0; font-weight: 600; word-break: break-word; }
        .label .imbas { margin-top: 3mm; font-size: 7.5pt; color: #6c757d; }

        .empty { grid-column: 1 / -1; text-align: center; padding: 60px 20px; color: #6c757d; }
        .empty i { font-size: 40px; display: block; margin-bottom: 10px; color: #adb5bd; }

        @media (max-width: 820px) {
            .sheet { width: auto; min-height: 0; margin: 12px; padding: 12px; grid-template-columns: 1fr; }
        }

        @page { size: A4; margin: 10mm; }
        @media print {
            body { background: #fff; }
            .qr-toolbar { display: none; }
            .sheet { width: auto; min-height: 0; margin: 0; padding: 0; box-shadow: none; grid-template-columns: 1fr 1fr; }
            .label { border-color: #868e96; }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <div class="qr-toolbar">
            <div>
                <h1>Cetak QR Sepanduk / Bunting</h1>
                <p><asp:Literal ID="litRingkasan" runat="server" /></p>
            </div>
            <div class="btns">
                <button type="button" class="btn" onclick="window.close();"><i class="bi bi-x-lg"></i>Tutup</button>
                <button type="button" class="btn btn-primary" onclick="window.print();"><i class="bi bi-printer"></i>Cetak</button>
            </div>
        </div>

        <div class="sheet">
            <asp:Repeater ID="rptLabel" runat="server">
                <ItemTemplate>
                    <div class="label">
                        <div class="label-head">
                            <img src='<%# ResolveUrl("~/images/logo.png") %>' alt="Logo" />
                            <div class="org">
                                <b>Majlis Perbandaran Kluang</b>
                                <span>Permit Sepanduk / Bunting</span>
                            </div>
                        </div>

                        <img class="qr" src='<%# ResolveUrl("~/QrBanting.ashx?id=" & HttpUtility.UrlEncode(Convert.ToString(Eval("UniqueID"))) & "&t=" & HttpUtility.UrlEncode(Convert.ToString(Request.QueryString("t")))) %>' alt="Kod QR" />
                        <div class="kod"><%# HttpUtility.HtmlEncode(Eval("UniqueID")) %></div>

                        <div class="lokasi-no">Lokasi <%# Eval("LokasiNo") %></div>
                        <div class="lokasi"><%# HttpUtility.HtmlEncode(Nilai(Eval("Lokasi"))) %></div>

                        <dl>
                            <div><dt>No. Rujukan</dt><dd><%# HttpUtility.HtmlEncode(Nilai(Eval("Rujukan"))) %></dd></div>
                            <div><dt>Syarikat</dt><dd><%# HttpUtility.HtmlEncode(Nilai(Eval("NamaSyarikat"))) %></dd></div>
                            <div><dt>Tempoh</dt><dd><%# Tempoh(Eval("TarikhBanting1"), Eval("TarikhBanting2")) %></dd></div>
                        </dl>

                        <div class="imbas">Imbas kod QR untuk semak status permit</div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:PlaceHolder ID="phTiada" runat="server" Visible="false">
                <div class="empty">
                    <i class="bi bi-qr-code"></i>
                    Kod QR tidak dijumpai atau permohonan belum diluluskan.
                </div>
            </asp:PlaceHolder>
        </div>

    </form>
</body>
</html>
