<%@ Page Title="Migrasi Data & Surat Lama" Language="VB" MasterPageFile="~/MasterMenu.master" AutoEventWireup="false" CodeFile="migratedata.aspx.vb" Inherits="lesen_migratedata" MaintainScrollPositionOnPostback="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .migrate-container {
            padding: 15px 10px 40px 10px;
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
        }
        .migrate-header-card {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: #ffffff;
            border-radius: 8px;
            padding: 20px 24px;
            margin-bottom: 20px;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.12);
        }
        .migrate-header-card h3 {
            margin: 0 0 6px 0;
            font-weight: 600;
            font-size: 21px;
        }
        .migrate-header-card p {
            margin: 0;
            opacity: 0.9;
            font-size: 13.5px;
        }
        .stat-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 20px;
        }
        .stat-card {
            flex: 1 1 220px;
            background: #ffffff;
            border-radius: 8px;
            border: 1px solid #e2e8f0;
            border-left: 5px solid #2a5298;
            padding: 15px 18px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.04);
        }
        .stat-card.card-format { border-left-color: #2563eb; }
        .stat-card.card-sp { border-left-color: #0891b2; }
        .stat-card.card-sk { border-left-color: #16a34a; }
        .stat-card.card-sb { border-left-color: #ea580c; }

        .stat-card .stat-title {
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #64748b;
            font-weight: 600;
            margin-bottom: 6px;
        }
        .stat-card .stat-value {
            font-size: 26px;
            font-weight: 700;
            color: #0f172a;
            line-height: 1.1;
            margin-bottom: 6px;
        }
        .stat-card .stat-sub {
            font-size: 12px;
            color: #475569;
        }
        .panel-box {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            margin-bottom: 20px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.04);
            overflow: hidden;
        }
        .panel-box-header {
            background: #f8fafc;
            border-bottom: 1px solid #e2e8f0;
            padding: 12px 18px;
            font-weight: 600;
            font-size: 14px;
            color: #1e293b;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .panel-box-body {
            padding: 18px;
        }
        .option-list {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 12px;
            margin-bottom: 16px;
        }
        .option-item {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            padding: 10px 14px;
            display: flex;
            align-items: flex-start;
            gap: 10px;
        }
        .option-item input[type="checkbox"] {
            margin-top: 3px;
            width: 16px;
            height: 16px;
            cursor: pointer;
        }
        .option-item label {
            margin: 0;
            cursor: pointer;
            font-weight: 600;
            font-size: 13px;
            color: #1e293b;
        }
        .option-item .option-desc {
            font-size: 11.5px;
            color: #64748b;
            font-weight: normal;
            margin-top: 2px;
        }
        .control-bar {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            padding-top: 12px;
            border-top: 1px solid #f1f5f9;
        }
        .btn-migrate {
            padding: 9px 18px;
            border-radius: 6px;
            font-weight: 600;
            font-size: 13.5px;
            border: none;
            cursor: pointer;
            transition: all 0.15s ease;
            display: inline-flex;
            align-items: center;
            gap: 7px;
        }
        .btn-migrate:disabled {
            opacity: 0.55;
            cursor: not-allowed;
        }
        .btn-start {
            background: #16a34a;
            color: #ffffff;
        }
        .btn-start:hover:not(:disabled) {
            background: #15803d;
        }
        .btn-stop {
            background: #dc2626;
            color: #ffffff;
        }
        .btn-stop:hover:not(:disabled) {
            background: #b91c1c;
        }
        .btn-refresh {
            background: #2563eb;
            color: #ffffff;
        }
        .btn-refresh:hover:not(:disabled) {
            background: #1d4ed8;
        }
        .btn-secondary-sm {
            background: #f1f5f9;
            color: #334155;
            border: 1px solid #cbd5e1;
            padding: 5px 12px;
            border-radius: 5px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
        }
        .btn-secondary-sm:hover {
            background: #e2e8f0;
        }
        .progress-wrapper {
            background: #e2e8f0;
            border-radius: 10px;
            height: 26px;
            width: 100%;
            overflow: hidden;
            position: relative;
            margin: 12px 0;
            box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.12);
        }
        .progress-bar-fill {
            height: 100%;
            width: 0%;
            background: linear-gradient(90deg, #2563eb 0%, #16a34a 100%);
            transition: width 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            font-size: 12.5px;
            font-weight: 700;
            white-space: nowrap;
        }
        .status-banner {
            background: #f8fafc;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
            padding: 12px 15px;
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
            align-items: center;
            gap: 10px;
            margin-bottom: 12px;
        }
        .status-indicator {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-weight: 600;
            color: #0f172a;
            font-size: 13.5px;
        }
        .pulse-dot {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background: #94a3b8;
            display: inline-block;
        }
        .pulse-dot.running {
            background: #16a34a;
            box-shadow: 0 0 0 rgba(22, 163, 74, 0.6);
            animation: pulseAnim 1.4s infinite;
        }
        .pulse-dot.stopped {
            background: #ea580c;
        }
        .pulse-dot.done {
            background: #2563eb;
        }
        @keyframes pulseAnim {
            0% { box-shadow: 0 0 0 0 rgba(22, 163, 74, 0.6); }
            70% { box-shadow: 0 0 0 8px rgba(22, 163, 74, 0); }
            100% { box-shadow: 0 0 0 0 rgba(22, 163, 74, 0); }
        }
        .metrics-row {
            display: flex;
            flex-wrap: wrap;
            gap: 18px;
            font-size: 12.5px;
            color: #334155;
        }
        .metrics-row span strong {
            color: #0f172a;
        }
        .log-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px;
        }
        @media (max-width: 992px) {
            .log-grid {
                grid-template-columns: 1fr;
            }
        }
        .log-console {
            height: 340px;
            overflow-y: auto;
            background: #0f172a;
            color: #e2e8f0;
            font-family: Consolas, Monaco, "Courier New", monospace;
            font-size: 12px;
            padding: 12px;
            border-radius: 6px;
            line-height: 1.55;
        }
        .log-entry {
            padding: 3px 0;
            border-bottom: 1px dashed rgba(255, 255, 255, 0.08);
        }
        .log-entry .log-time {
            color: #94a3b8;
            margin-right: 6px;
        }
        .log-entry .log-badge {
            display: inline-block;
            padding: 1px 6px;
            border-radius: 3px;
            font-size: 10.5px;
            font-weight: 700;
            margin-right: 6px;
        }
        .badge-success { background: #16a34a; color: #fff; }
        .badge-error { background: #dc2626; color: #fff; }
        .badge-info { background: #2563eb; color: #fff; }
        .badge-warn { background: #d97706; color: #fff; }
        .log-entry a {
            color: #38bdf8;
            text-decoration: underline;
            margin-left: 6px;
        }
        .error-table-wrapper {
            height: 340px;
            overflow-y: auto;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
        }
        .error-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 12px;
        }
        .error-table th {
            position: sticky;
            top: 0;
            background: #fef2f2;
            color: #991b1b;
            border-bottom: 1px solid #fecaca;
            padding: 8px 10px;
            text-align: left;
            font-weight: 600;
        }
        .error-table td {
            padding: 7px 10px;
            border-bottom: 1px solid #f1f5f9;
            color: #334155;
            vertical-align: top;
        }
        .error-table tr:hover td {
            background: #fff5f5;
        }
        .badge-counter {
            background: #e2e8f0;
            color: #1e293b;
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 700;
        }
        .badge-counter.danger {
            background: #fee2e2;
            color: #991b1b;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="migrate-container">
        <!-- Header Banner -->
        <div class="migrate-header-card">
            <h3><i class="fa fa-database"></i> Migrasi Data Lama &amp; Penjanaan PDF Surat / Laporan</h3>
            <p>
                Kemaskini rekod lama daripada halaman asal (<code>appregister</code>, <code>semakansurat</code>, <code>kelulusan</code>, <code>pembatalan</code>, <code>semakkelulusan</code>, <code>semakpembatalan</code>)
                supaya mematuhi format jadual MS SQL baharu (<code>appregister1</code>, <code>appregister2</code>, <code>semakansurat1</code>, <code>kelulusan1</code>, <code>pembatalan1</code>, <code>semakkelulusan1</code>, <code>semakpembatalan1</code>)
                serta simpan isi surat/laporan sebagai fail PDF (<code>IsSuratPemeriksaanFail</code>, <code>IsSuratKelulusanFail</code>, <code>IsSuratPembatalanFail</code>).
                Jadual <code>LESEN_PermohonanSurat</code> tidak diubah.
            </p>
        </div>

        <!-- Summary Cards -->
        <div class="stat-grid">
            <div class="stat-card card-format">
                <div class="stat-title">Format Data Jadual SQL</div>
                <div class="stat-value" id="lblPendingFormat">-</div>
                <div class="stat-sub" id="lblSubFormat">Menyemak rekod...</div>
            </div>
            <div class="stat-card card-sp">
                <div class="stat-title">PDF Laporan Pemeriksaan (SP)</div>
                <div class="stat-value" id="lblPendingSP">-</div>
                <div class="stat-sub" id="lblSubSP">Sedia ada: -</div>
            </div>
            <div class="stat-card card-sk">
                <div class="stat-title">PDF Surat Kelulusan (SK)</div>
                <div class="stat-value" id="lblPendingSK">-</div>
                <div class="stat-sub" id="lblSubSK">Sedia ada: -</div>
            </div>
            <div class="stat-card card-sb">
                <div class="stat-title">PDF Surat Pembatalan (SB)</div>
                <div class="stat-value" id="lblPendingSB">-</div>
                <div class="stat-sub" id="lblSubSB">Sedia ada: -</div>
            </div>
        </div>

        <!-- Configuration & Action Controls -->
        <div class="panel-box">
            <div class="panel-box-header">
                <span><i class="fa fa-cogs"></i> Tetapan &amp; Kawalan Migrasi</span>
                <span style="font-size:12px; color:#64748b;">Jumlah Keseluruhan Rekod Permohonan: <strong id="lblTotalPermohonan">-</strong></span>
            </div>
            <div class="panel-box-body">
                <div class="option-list">
                    <div class="option-item">
                        <input type="checkbox" id="chkIncludeFormat" checked="checked" />
                        <div>
                            <label for="chkIncludeFormat">1. Kemaskini Format Data Jadual MS SQL</label>
                            <div class="option-desc">
                                Kemaskini <code>JenisLesenIdList</code>, <code>JenisLesenDescList</code>, <code>SaizIklanList</code>, <code>CahayaIklanList</code>, <code>UnitIklanList</code>,
                                <code>BakaAnjingList</code>, <code>Anjing*List</code> dalam <code>LESEN_Permohonan</code> &amp; <code>LESEN_PermohonanPembetulan</code>.
                            </div>
                        </div>
                    </div>
                    <div class="option-item">
                        <input type="checkbox" id="chkIncludeSP" checked="checked" />
                        <div>
                            <label for="chkIncludeSP">2. Jana PDF Laporan Pemeriksaan (<code>IsSuratPemeriksaanFail</code>)</label>
                            <div class="option-desc">
                                Jika <code>SuratPemeriksaan1</code> / <code>SuratPemeriksaan2</code> tidak kosong, simpan sebagai PDF (<code>SP</code>) dalam <code>LESEN_PermohonanFail</code> &amp; set <code>IsSuratPemeriksaanFail = 1</code>.
                            </div>
                        </div>
                    </div>
                    <div class="option-item">
                        <input type="checkbox" id="chkIncludeSK" checked="checked" />
                        <div>
                            <label for="chkIncludeSK">3. Jana PDF Surat Kelulusan (<code>IsSuratKelulusanFail</code>)</label>
                            <div class="option-desc">
                                Jika <code>SuratKelulusan1..4</code> tidak kosong, simpan sebagai PDF (<code>SK</code>) dalam <code>LESEN_PermohonanFail</code> &amp; set <code>IsSuratKelulusanFail = 1</code>.
                            </div>
                        </div>
                    </div>
                    <div class="option-item">
                        <input type="checkbox" id="chkIncludeSB" checked="checked" />
                        <div>
                            <label for="chkIncludeSB">4. Jana PDF Surat Pembatalan (<code>IsSuratPembatalanFail</code>)</label>
                            <div class="option-desc">
                                Jika <code>SuratPembatalan1..2</code> tidak kosong, simpan sebagai PDF (<code>SB</code>) dalam <code>LESEN_PermohonanFail</code> &amp; set <code>IsSuratPembatalanFail = 1</code>.
                            </div>
                        </div>
                    </div>
                </div>

                <div class="control-bar">
                    <div style="display:flex; flex-wrap:wrap; align-items:center; gap:16px;">
                        <div>
                            <label for="ddlBatchSize" style="font-size:12.5px; font-weight:600; color:#334155; margin-right:6px;">Saiz Kelompok (Batch):</label>
                            <select id="ddlBatchSize" style="padding:5px 10px; border:1px solid #cbd5e1; border-radius:5px; font-size:12.5px;">
                                <option value="5">5 rekod / kelompok</option>
                                <option value="10" selected="selected">10 rekod / kelompok</option>
                                <option value="20">20 rekod / kelompok</option>
                                <option value="50">50 rekod / kelompok</option>
                            </select>
                        </div>
                        <div style="display:flex; align-items:center; gap:6px;">
                            <input type="checkbox" id="chkForcePdf" />
                            <label for="chkForcePdf" style="font-size:12.5px; color:#475569; margin:0; cursor:pointer;">
                                Jana semula PDF walaupun fail telah wujud
                            </label>
                        </div>
                    </div>

                    <div style="display:flex; flex-wrap:wrap; gap:10px;">
                        <button type="button" id="btnRefreshSummary" class="btn-migrate btn-refresh" onclick="loadMigrationSummary();">
                            <i class="fa fa-refresh"></i> Semak Semula Kiraan
                        </button>
                        <button type="button" id="btnStartMigration" class="btn-migrate btn-start" onclick="startMigration();">
                            <i class="fa fa-play"></i> Mula Migrasi Data
                        </button>
                        <button type="button" id="btnStopMigration" class="btn-migrate btn-stop" onclick="stopMigration();" disabled="disabled">
                            <i class="fa fa-stop"></i> Henti Migrasi
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Progress Bar & Current Status / Activity -->
        <div class="panel-box">
            <div class="panel-box-header">
                <span><i class="fa fa-tasks"></i> Kemajuan &amp; Status Semasa Migrasi</span>
                <span id="lblProgressCounter" class="badge-counter">0 / 0 Rekod (0%)</span>
            </div>
            <div class="panel-box-body">
                <div class="status-banner">
                    <div class="status-indicator">
                        <span id="statusDot" class="pulse-dot"></span>
                        <span id="lblCurrentActivity">Sedia untuk memulakan proses migrasi.</span>
                    </div>
                    <div style="font-size:12.5px; color:#475569;">
                        Masa Berlalu: <strong id="lblElapsedTime">00:00:00</strong> |
                        Anggaran Baki Masa: <strong id="lblEtaTime">--:--:--</strong>
                    </div>
                </div>

                <div class="progress-wrapper">
                    <div id="progressBarFill" class="progress-bar-fill">0%</div>
                </div>

                <div class="metrics-row">
                    <span>Rekod Diproses: <strong id="metricProcessed">0</strong></span>
                    <span>Format SQL Dikemaskini: <strong id="metricFormat">0</strong></span>
                    <span>PDF Pemeriksaan (SP) Dijana: <strong id="metricSP">0</strong></span>
                    <span>PDF Kelulusan (SK) Dijana: <strong id="metricSK">0</strong></span>
                    <span>PDF Pembatalan (SB) Dijana: <strong id="metricSB">0</strong></span>
                    <span>Jumlah Ralat: <strong id="metricErrors" style="color:#dc2626;">0</strong></span>
                </div>
            </div>
        </div>

        <!-- Activity Log & Error Log -->
        <div class="log-grid">
            <!-- Live Activity Log -->
            <div class="panel-box" style="margin-bottom:0;">
                <div class="panel-box-header">
                    <span><i class="fa fa-list-alt"></i> Log Aktiviti Semasa</span>
                    <div>
                        <button type="button" class="btn-secondary-sm" onclick="clearActivityLog();">Kosongkan Log</button>
                    </div>
                </div>
                <div class="panel-box-body" style="padding:12px;">
                    <div id="activityConsole" class="log-console">
                        <div class="log-entry">
                            <span class="log-time">[Sistem]</span>
                            <span class="log-badge badge-info">INFO</span>
                            Halaman migrasi sedia. Klik <strong>Mula Migrasi Data</strong> untuk memulakan pengemaskinian.
                        </div>
                    </div>
                </div>
            </div>

            <!-- Error Log -->
            <div class="panel-box" style="margin-bottom:0;">
                <div class="panel-box-header">
                    <span>
                        <i class="fa fa-exclamation-triangle" style="color:#dc2626;"></i> Log Ralat (Error Log)
                        <span id="badgeErrorCount" class="badge-counter danger" style="margin-left:6px;">0</span>
                    </span>
                    <div style="display:flex; gap:6px;">
                        <button type="button" class="btn-secondary-sm" onclick="exportErrorLogCsv();">Muat Turun CSV</button>
                        <button type="button" class="btn-secondary-sm" onclick="clearErrorLog();">Kosongkan</button>
                    </div>
                </div>
                <div class="panel-box-body" style="padding:12px;">
                    <div class="error-table-wrapper">
                        <table class="error-table">
                            <thead>
                                <tr>
                                    <th style="width:42px;">#</th>
                                    <th style="width:72px;">Masa</th>
                                    <th style="width:85px;">ID / Rujukan</th>
                                    <th style="width:130px;">Langkah</th>
                                    <th>Mesej Ralat</th>
                                </tr>
                            </thead>
                            <tbody id="errorTableBody">
                                <tr id="rowNoError">
                                    <td colspan="5" style="text-align:center; color:#94a3b8; padding:24px;">
                                        Tiada ralat direkodkan.
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        var isMigrating = false;
        var stopRequested = false;
        var migrationQueue = [];
        var currentIndex = 0;
        var startTimeMs = 0;
        var elapsedTimerId = null;

        var totalProcessed = 0;
        var totalFormatUpdated = 0;
        var totalSPGenerated = 0;
        var totalSKGenerated = 0;
        var totalSBGenerated = 0;
        var totalErrors = 0;
        var errorList = [];

        document.addEventListener("DOMContentLoaded", function () {
            loadMigrationSummary();
        });

        function callPageMethod(methodName, payload, onSuccess, onError) {
            var xhr = new XMLHttpRequest();
            xhr.open("POST", "migratedata.aspx/" + methodName, true);
            xhr.setRequestHeader("Content-Type", "application/json; charset=utf-8");
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4) {
                    if (xhr.status >= 200 && xhr.status < 300) {
                        try {
                            var parsed = JSON.parse(xhr.responseText);
                            var data = (parsed && typeof parsed.d !== "undefined") ? parsed.d : parsed;
                            onSuccess(data);
                        } catch (e) {
                            onError("Ralat menghurai respons JSON: " + e.message);
                        }
                    } else {
                        onError("Ralat pelayan HTTP " + xhr.status + ": " + xhr.statusText);
                    }
                }
            };
            xhr.onerror = function () {
                onError("Ralat rangkaian semasa menghubungi pelayan.");
            };
            xhr.send(JSON.stringify(payload || {}));
        }

        function loadMigrationSummary() {
            document.getElementById("lblCurrentActivity").innerText = "Menyemak ringkasan pangkalan data...";
            callPageMethod("GetMigrationSummary", {}, function (res) {
                if (!res || !res.Success) {
                    appendActivityLog("ERROR", "-", "-", "Ringkasan", (res && res.Message) ? res.Message : "Gagal menyemak status data.", "");
                    document.getElementById("lblCurrentActivity").innerText = "Ralat menyemak ringkasan data.";
                    return;
                }
                document.getElementById("lblTotalPermohonan").innerText = res.TotalPermohonan.toLocaleString();
                document.getElementById("lblPendingFormat").innerText = res.PendingFormatCount.toLocaleString();
                document.getElementById("lblSubFormat").innerText =
                    "JenisLesenList: " + res.PendingJenisLesenListCount +
                    " | Iklan: " + res.PendingIklanListCount +
                    " | Anjing: " + res.PendingAnjingListCount +
                    " | Pembetulan: " + res.PendingPembetulanCount;

                document.getElementById("lblPendingSP").innerText = res.PendingSPCount.toLocaleString();
                document.getElementById("lblSubSP").innerText = "Telah dijana (IsSuratPemeriksaanFail=1): " + res.CompletedSPCount.toLocaleString();

                document.getElementById("lblPendingSK").innerText = res.PendingSKCount.toLocaleString();
                document.getElementById("lblSubSK").innerText = "Telah dijana (IsSuratKelulusanFail=1): " + res.CompletedSKCount.toLocaleString();

                document.getElementById("lblPendingSB").innerText = res.PendingSBCount.toLocaleString();
                document.getElementById("lblSubSB").innerText = "Telah dijana (IsSuratPembatalanFail=1): " + res.CompletedSBCount.toLocaleString();

                if (!isMigrating) {
                    document.getElementById("lblCurrentActivity").innerText = "Ringkasan data dikemaskini. Sedia untuk memulakan migrasi.";
                }
            }, function (errMsg) {
                appendActivityLog("ERROR", "-", "-", "Ringkasan", errMsg, "");
                document.getElementById("lblCurrentActivity").innerText = errMsg;
            });
        }

        function startMigration() {
            if (isMigrating) return;

            var incFormat = document.getElementById("chkIncludeFormat").checked;
            var incSP = document.getElementById("chkIncludeSP").checked;
            var incSK = document.getElementById("chkIncludeSK").checked;
            var incSB = document.getElementById("chkIncludeSB").checked;
            var forcePdf = document.getElementById("chkForcePdf").checked;

            if (!incFormat && !incSP && !incSK && !incSB) {
                alert("Sila pilih sekurang-kurangnya satu tugas migrasi terlebih dahulu.");
                return;
            }

            isMigrating = true;
            stopRequested = false;
            currentIndex = 0;
            totalProcessed = 0;
            totalFormatUpdated = 0;
            totalSPGenerated = 0;
            totalSKGenerated = 0;
            totalSBGenerated = 0;
            updateMetricsUI();

            setButtonsState(true);
            setStatusDot("running");
            document.getElementById("lblCurrentActivity").innerText = "Sedang memuatkan senarai rekod untuk dikemaskini...";
            appendActivityLog("INFO", "-", "-", "Sistem", "Memuatkan senarai rekod yang memerlukan kemaskinian...", "");

            callPageMethod("GetPendingQueue", {
                includeFormat: incFormat,
                includeSP: incSP,
                includeSK: incSK,
                includeSB: incSB,
                forceRegeneratePdf: forcePdf
            }, function (res) {
                if (!res || !res.Success) {
                    isMigrating = false;
                    setButtonsState(false);
                    setStatusDot("stopped");
                    var msg = (res && res.Message) ? res.Message : "Gagal memuatkan senarai rekod.";
                    document.getElementById("lblCurrentActivity").innerText = msg;
                    appendActivityLog("ERROR", "-", "-", "Sistem", msg, "");
                    return;
                }

                migrationQueue = res.Items || [];
                if (migrationQueue.length === 0) {
                    isMigrating = false;
                    setButtonsState(false);
                    setStatusDot("done");
                    updateProgressBar(0, 0);
                    document.getElementById("lblCurrentActivity").innerText = "Tiada rekod tertunggak ditemui. Semua rekod telah mengikut format baharu.";
                    appendActivityLog("SUCCESS", "-", "-", "Sistem", "Tiada rekod tertunggak ditemui. Semua data & PDF telah dikemaskini.", "");
                    loadMigrationSummary();
                    return;
                }

                appendActivityLog("INFO", "-", "-", "Sistem", "Sebanyak " + migrationQueue.length + " rekod ditemui untuk diproses. Memulakan kelompok...", "");
                startTimeMs = Date.now();
                startElapsedTimer();
                updateProgressBar(0, migrationQueue.length);
                processNextBatch();
            }, function (errMsg) {
                isMigrating = false;
                setButtonsState(false);
                setStatusDot("stopped");
                document.getElementById("lblCurrentActivity").innerText = errMsg;
                appendActivityLog("ERROR", "-", "-", "Sistem", errMsg, "");
            });
        }

        function processNextBatch() {
            if (stopRequested) {
                finishMigration(true);
                return;
            }

            if (currentIndex >= migrationQueue.length) {
                finishMigration(false);
                return;
            }

            var batchSize = parseInt(document.getElementById("ddlBatchSize").value, 10) || 10;
            var forcePdf = document.getElementById("chkForcePdf").checked;
            var endIdx = Math.min(currentIndex + batchSize, migrationQueue.length);
            var batchItems = migrationQueue.slice(currentIndex, endIdx);

            var firstItem = batchItems[0];
            var lastItem = batchItems[batchItems.length - 1];
            document.getElementById("lblCurrentActivity").innerText =
                "Memproses rekod " + (currentIndex + 1) + " hingga " + endIdx + " daripada " + migrationQueue.length +
                " (Permohonan ID: " + firstItem.PermohonanID + " [" + firstItem.Rujukan + "] - " + lastItem.PermohonanID + ")...";

            callPageMethod("ProcessMigrationBatch", {
                items: batchItems,
                forceRegeneratePdf: forcePdf
            }, function (res) {
                if (res && res.Success) {
                    currentIndex = endIdx;
                    totalProcessed += (res.ProcessedCount || batchItems.length);
                    totalFormatUpdated += (res.FormatUpdatedCount || 0);
                    totalSPGenerated += (res.SPGeneratedCount || 0);
                    totalSKGenerated += (res.SKGeneratedCount || 0);
                    totalSBGenerated += (res.SBGeneratedCount || 0);

                    if (res.Activities && res.Activities.length > 0) {
                        for (var i = 0; i < res.Activities.length; i++) {
                            var a = res.Activities[i];
                            appendActivityLog(a.Status, a.PermohonanID, a.Rujukan, a.Category, a.Message, a.FileUrl);
                        }
                    }

                    if (res.Errors && res.Errors.length > 0) {
                        for (var j = 0; j < res.Errors.length; j++) {
                            appendErrorRow(res.Errors[j]);
                        }
                    }

                    updateMetricsUI();
                    updateProgressBar(currentIndex, migrationQueue.length);

                    setTimeout(processNextBatch, 60);
                } else {
                    var msg = (res && res.Message) ? res.Message : "Ralat tidak diketahui semasa memproses kelompok.";
                    appendActivityLog("ERROR", firstItem.PermohonanID, firstItem.Rujukan, "Kelompok", msg, "");
                    appendErrorRow({
                        Timestamp: new Date().toLocaleTimeString(),
                        PermohonanID: firstItem.PermohonanID,
                        Rujukan: firstItem.Rujukan,
                        StepName: "ProcessMigrationBatch",
                        ErrorMessage: msg
                    });
                    currentIndex = endIdx;
                    updateMetricsUI();
                    updateProgressBar(currentIndex, migrationQueue.length);
                    setTimeout(processNextBatch, 150);
                }
            }, function (errMsg) {
                appendActivityLog("ERROR", firstItem.PermohonanID, firstItem.Rujukan, "Rangkaian", errMsg, "");
                appendErrorRow({
                    Timestamp: new Date().toLocaleTimeString(),
                    PermohonanID: firstItem.PermohonanID,
                    Rujukan: firstItem.Rujukan,
                    StepName: "HTTP Request",
                    ErrorMessage: errMsg
                });
                currentIndex = endIdx;
                updateMetricsUI();
                updateProgressBar(currentIndex, migrationQueue.length);
                setTimeout(processNextBatch, 250);
            });
        }

        function stopMigration() {
            if (!isMigrating) return;
            stopRequested = true;
            document.getElementById("btnStopMigration").disabled = true;
            document.getElementById("lblCurrentActivity").innerText = "Menghentikan migrasi selepas kelompok semasa selesai...";
            appendActivityLog("WARN", "-", "-", "Sistem", "Permintaan henti diterima. Menunggu kelompok semasa tamat...", "");
        }

        function finishMigration(wasStopped) {
            isMigrating = false;
            stopElapsedTimer();
            setButtonsState(false);

            if (wasStopped) {
                setStatusDot("stopped");
                document.getElementById("lblCurrentActivity").innerText =
                    "Migrasi dihentikan oleh pengguna pada rekod " + currentIndex + " / " + migrationQueue.length + ".";
                appendActivityLog("WARN", "-", "-", "Sistem", "Migrasi dihentikan pada rekod " + currentIndex + " / " + migrationQueue.length + ".", "");
            } else {
                setStatusDot("done");
                document.getElementById("lblCurrentActivity").innerText =
                    "Migrasi selesai sepenuhnya! (" + totalProcessed + " rekod telah diproses).";
                appendActivityLog("SUCCESS", "-", "-", "Sistem",
                    "Migrasi selesai! Format SQL: " + totalFormatUpdated +
                    ", PDF SP: " + totalSPGenerated +
                    ", PDF SK: " + totalSKGenerated +
                    ", PDF SB: " + totalSBGenerated +
                    ", Ralat: " + totalErrors + ".", "");
            }

            loadMigrationSummary();
        }

        function updateProgressBar(done, total) {
            var pct = 0;
            if (total > 0) {
                pct = Math.round((done / total) * 100);
            } else if (!isMigrating) {
                pct = 100;
            }
            var fill = document.getElementById("progressBarFill");
            fill.style.width = pct + "%";
            fill.innerText = pct + "%";
            document.getElementById("lblProgressCounter").innerText =
                done.toLocaleString() + " / " + total.toLocaleString() + " Rekod (" + pct + "%)";

            if (done > 0 && total > done && startTimeMs > 0) {
                var elapsedSec = (Date.now() - startTimeMs) / 1000;
                var rate = done / elapsedSec;
                if (rate > 0) {
                    var remainSec = Math.round((total - done) / rate);
                    document.getElementById("lblEtaTime").innerText = formatDuration(remainSec);
                }
            } else if (done >= total && total > 0) {
                document.getElementById("lblEtaTime").innerText = "00:00:00";
            }
        }

        function updateMetricsUI() {
            document.getElementById("metricProcessed").innerText = totalProcessed.toLocaleString();
            document.getElementById("metricFormat").innerText = totalFormatUpdated.toLocaleString();
            document.getElementById("metricSP").innerText = totalSPGenerated.toLocaleString();
            document.getElementById("metricSK").innerText = totalSKGenerated.toLocaleString();
            document.getElementById("metricSB").innerText = totalSBGenerated.toLocaleString();
            document.getElementById("metricErrors").innerText = totalErrors.toLocaleString();
            document.getElementById("badgeErrorCount").innerText = totalErrors.toLocaleString();
        }

        function appendActivityLog(status, pid, rujukan, category, message, fileUrl) {
            var consoleEl = document.getElementById("activityConsole");
            var div = document.createElement("div");
            div.className = "log-entry";

            var badgeClass = "badge-info";
            if (status === "SUCCESS") badgeClass = "badge-success";
            else if (status === "ERROR") badgeClass = "badge-error";
            else if (status === "WARN") badgeClass = "badge-warn";

            var nowStr = new Date().toLocaleTimeString();
            var idLabel = (pid && pid !== "-") ? " [ID:" + pid + " | " + escapeHtml(rujukan || "-") + "] " : " ";

            var html = '<span class="log-time">[' + nowStr + ']</span>' +
                       '<span class="log-badge ' + badgeClass + '">' + escapeHtml(category) + '</span>' +
                       '<strong>' + idLabel + '</strong>' +
                       escapeHtml(message);

            if (fileUrl && fileUrl.length > 0) {
                html += ' <a href="' + escapeHtml(fileUrl) + '" target="_blank">[Lihat PDF]</a>';
            }

            div.innerHTML = html;
            consoleEl.appendChild(div);

            while (consoleEl.children.length > 500) {
                consoleEl.removeChild(consoleEl.firstChild);
            }
            consoleEl.scrollTop = consoleEl.scrollHeight;
        }

        function appendErrorRow(err) {
            totalErrors++;
            errorList.push(err);

            var tbody = document.getElementById("errorTableBody");
            var noErrRow = document.getElementById("rowNoError");
            if (noErrRow) {
                noErrRow.parentNode.removeChild(noErrRow);
            }

            var tr = document.createElement("tr");
            tr.innerHTML =
                "<td>" + errorList.length + "</td>" +
                "<td>" + escapeHtml(err.Timestamp || "") + "</td>" +
                "<td><strong>" + escapeHtml(String(err.PermohonanID || "-")) + "</strong><br/><span style='color:#64748b;font-size:11px;'>" + escapeHtml(err.Rujukan || "-") + "</span></td>" +
                "<td>" + escapeHtml(err.StepName || "") + "</td>" +
                "<td style='color:#b91c1c;'>" + escapeHtml(err.ErrorMessage || "") + "</td>";
            tbody.appendChild(tr);
        }

        function clearActivityLog() {
            var consoleEl = document.getElementById("activityConsole");
            consoleEl.innerHTML = "";
            appendActivityLog("INFO", "-", "-", "Sistem", "Log aktiviti telah dikosongkan.", "");
        }

        function clearErrorLog() {
            errorList = [];
            totalErrors = 0;
            updateMetricsUI();
            var tbody = document.getElementById("errorTableBody");
            tbody.innerHTML = '<tr id="rowNoError"><td colspan="5" style="text-align:center; color:#94a3b8; padding:24px;">Tiada ralat direkodkan.</td></tr>';
        }

        function exportErrorLogCsv() {
            if (!errorList || errorList.length === 0) {
                alert("Tiada rekod ralat untuk dimuat turun.");
                return;
            }
            var lines = ["Bil,Masa,Permohonan_ID,Rujukan,Langkah,Mesej_Ralat"];
            for (var i = 0; i < errorList.length; i++) {
                var e = errorList[i];
                lines.push([
                    i + 1,
                    csvEscape(e.Timestamp),
                    csvEscape(e.PermohonanID),
                    csvEscape(e.Rujukan),
                    csvEscape(e.StepName),
                    csvEscape(e.ErrorMessage)
                ].join(","));
            }
            var csvContent = "\uFEFF" + lines.join("\r\n");
            var blob = new Blob([csvContent], { type: "text/csv;charset=utf-8;" });
            var link = document.createElement("a");
            link.href = URL.createObjectURL(blob);
            link.download = "Log_Ralat_Migrasi_" + new Date().toISOString().slice(0, 10) + ".csv";
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }

        function csvEscape(val) {
            var s = (val === null || typeof val === "undefined") ? "" : String(val);
            return '"' + s.replace(/"/g, '""') + '"';
        }

        function setButtonsState(running) {
            document.getElementById("btnStartMigration").disabled = running;
            document.getElementById("btnRefreshSummary").disabled = running;
            document.getElementById("btnStopMigration").disabled = !running;
            document.getElementById("chkIncludeFormat").disabled = running;
            document.getElementById("chkIncludeSP").disabled = running;
            document.getElementById("chkIncludeSK").disabled = running;
            document.getElementById("chkIncludeSB").disabled = running;
            document.getElementById("ddlBatchSize").disabled = running;
            document.getElementById("chkForcePdf").disabled = running;
        }

        function setStatusDot(state) {
            var dot = document.getElementById("statusDot");
            dot.className = "pulse-dot";
            if (state) {
                dot.classList.add(state);
            }
        }

        function startElapsedTimer() {
            stopElapsedTimer();
            elapsedTimerId = setInterval(function () {
                var sec = Math.floor((Date.now() - startTimeMs) / 1000);
                document.getElementById("lblElapsedTime").innerText = formatDuration(sec);
            }, 1000);
        }

        function stopElapsedTimer() {
            if (elapsedTimerId) {
                clearInterval(elapsedTimerId);
                elapsedTimerId = null;
            }
        }

        function formatDuration(totalSec) {
            if (isNaN(totalSec) || totalSec < 0) return "00:00:00";
            var hrs = Math.floor(totalSec / 3600);
            var mins = Math.floor((totalSec % 3600) / 60);
            var secs = Math.floor(totalSec % 60);
            return pad2(hrs) + ":" + pad2(mins) + ":" + pad2(secs);
        }

        function pad2(n) {
            return n < 10 ? "0" + n : String(n);
        }

        function escapeHtml(str) {
            if (str === null || typeof str === "undefined") return "";
            return String(str)
                .replace(/&/g, "&amp;")
                .replace(/</g, "&lt;")
                .replace(/>/g, "&gt;")
                .replace(/"/g, "&quot;")
                .replace(/'/g, "&#039;");
        }
    </script>
</asp:Content>
