<%@ Page Title="" Language="VB" MasterPageFile="~/MasterMenu.master" AutoEventWireup="false" CodeFile="migratefile.aspx.vb" Inherits="lesen_migratefile" %>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="Server">
<style>
    .mf-card { background: #fff; border: 1px solid #E3E7F1; border-radius: 12px; box-shadow: 0 2px 8px rgba(46,49,146,.06); margin-bottom: 16px; overflow: hidden; }
    .mf-head { padding: 16px 20px; border-bottom: 1px solid #E4DFFB; background: linear-gradient(135deg, #F4F3FF 0%, #EEF4FF 100%); border-left: 4px solid #2E3192; display: flex; flex-wrap: wrap; gap: 12px; justify-content: space-between; align-items: center; }
    .mf-title { font-size: 17px; font-weight: 700; color: #23267a; margin: 0; }
    .mf-sub { color: #5B6478; font-size: 13px; }
    .mf-body { padding: 16px 20px; }
    .mf-path { font-family: Consolas, monospace; font-size: 12.5px; background: #F6F7FB; border: 1px solid #E3E7F1; border-radius: 6px; padding: 4px 8px; word-break: break-all; display: inline-block; }
    .mf-stats { display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 10px; margin-bottom: 14px; }
    .mf-stat { border: 1px solid #E3E7F1; border-radius: 10px; padding: 10px 14px; }
    .mf-stat .n { font-size: 22px; font-weight: 700; color: #23267a; }
    .mf-stat .l { font-size: 12px; color: #5B6478; }
    .mf-stat.warn .n { color: #b45309; } .mf-stat.bad .n { color: #b91c1c; } .mf-stat.good .n { color: #15803d; }
    .mf-log { max-height: 260px; overflow: auto; font-family: Consolas, monospace; font-size: 12px; background: #0f172a; color: #e2e8f0; border-radius: 8px; padding: 10px 12px; white-space: pre-wrap; }
    .mf-bar { height: 10px; background: #E3E7F1; border-radius: 999px; overflow: hidden; }
    .mf-bar > div { height: 100%; width: 0; background: #2E3192; transition: width .2s; }
</style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="Server">
    <section class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6"><h1 class="m-0 text-dark">Migrasi Fail</h1></div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <%= GlobalClass.writeBreadcrumb(Request.QueryString("p_Id"), Request.QueryString("m_Id"), Session.Item("sessionSystemId")) %>
                    </ol>
                </div>
            </div>
        </div>
    </section>

    <section class="content">
        <div class="container-fluid">
            <div class="mf-card">
                <div class="mf-head">
                    <div>
                        <h2 class="mf-title"><i class="bi bi-folder-symlink me-2"></i>Salin fail daripada sistem lama</h2>
                        <div class="mf-sub">Fail dirujuk oleh DB (doc, Uploads). Nama dan folder dikekalkan; fail sedia ada tidak ditimpa.</div>
                    </div>
                    <div class="d-flex gap-2">
                        <button type="button" class="btn btn-default btn-sm" id="btnMfAnalyse" onclick="mfDoAnalyse()"><i class="bi bi-search me-1"></i>Analisis</button>
                        <button type="button" class="btn btn-primary btn-sm" id="btnMfRun" onclick="mfDoRun()" disabled><i class="bi bi-play-fill me-1"></i>Salin fail</button>
                        <button type="button" class="btn btn-outline-danger btn-sm" id="btnMfStop" onclick="mfStopReq = true" style="display:none"><i class="bi bi-stop-fill me-1"></i>Henti</button>
                    </div>
                </div>
                <div class="mf-body">
                    <div class="mb-1"><b>Sumber (sistem lama):</b> <span class="mf-path"><%= If(String.IsNullOrEmpty(OldRoot), "(belum ditetapkan - tambah appSetting OldFileRoot dalam web.config)", HttpUtility.HtmlEncode(OldRoot)) %></span></div>
                    <div class="mb-1"><b>Destinasi (sistem baru):</b> <span class="mf-path"><%= HttpUtility.HtmlEncode(NewRoot) %></span></div>
                    <div class="mb-3"><b>DB sasaran (sumber kebenaran fail):</b> <span class="mf-path"><%= HttpUtility.HtmlEncode(DbSasaran) %></span> <span class="small text-muted">Folder sistem lama hanya dibaca, tidak diubah.</span></div>

                    <div id="mfStats" class="mf-stats" style="display:none">
                        <div class="mf-stat"><div class="n" id="sTotal">0</div><div class="l">Fail dirujuk DB</div></div>
                        <div class="mf-stat good"><div class="n" id="sExists">0</div><div class="l">Sudah wujud (dilangkau)</div></div>
                        <div class="mf-stat warn"><div class="n" id="sCopy">0</div><div class="l">Akan disalin</div></div>
                        <div class="mf-stat bad"><div class="n" id="sMissing">0</div><div class="l">Tiada di sumber</div></div>
                        <div class="mf-stat"><div class="n" id="sSize">0</div><div class="l">Saiz untuk disalin</div></div>
                    </div>
                    <div id="mfSrc" class="small text-muted mb-2"></div>

                    <div id="mfProg" style="display:none" class="mb-3">
                        <div class="d-flex justify-content-between small mb-1"><span id="mfProgText"></span><span id="mfProgPct"></span></div>
                        <div class="mf-bar"><div id="mfProgBar"></div></div>
                    </div>

                    <div id="mfLogWrap" style="display:none">
                        <div class="fw-bold small mb-1">Log</div>
                        <div class="mf-log" id="mfLog"></div>
                    </div>
                </div>
            </div>

            <div class="mf-card">
                <div class="mf-head">
                    <div>
                        <h2 class="mf-title"><i class="bi bi-trash3 me-2"></i>Fail yatim di sistem baru</h2>
                        <div class="mf-sub">Fail dalam doc/, Uploads/Banting dan Uploads/Sepanduk sistem baru yang tidak dirujuk oleh DB sasaran (cth. fail ujian).</div>
                    </div>
                    <div class="d-flex gap-2">
                        <button type="button" class="btn btn-default btn-sm" id="btnYtScan" onclick="mfYtScan()"><i class="bi bi-search me-1"></i>Imbas</button>
                        <button type="button" class="btn btn-danger btn-sm" id="btnYtDel" onclick="mfYtDelete()" disabled><i class="bi bi-trash3 me-1"></i>Padam fail yatim</button>
                    </div>
                </div>
                <div class="mf-body">
                    <div id="ytSummary" class="small mb-2"></div>
                    <div id="ytListWrap" style="display:none" class="mb-3">
                        <div class="table-responsive" style="max-height:260px;overflow:auto">
                            <table class="table table-sm mb-0"><thead><tr><th style="width:34px"><input type="checkbox" id="ytAll" onchange="mfYtAll(this.checked)" title="Pilih semua" /></th><th>Fail</th><th class="text-end">Saiz</th><th>Diubah</th></tr></thead><tbody id="ytList"></tbody></table>
                        </div>
                    </div>
                    <div id="ytProg" style="display:none">
                        <div class="mf-bar"><div id="ytBar"></div></div>
                        <div class="small mt-1" id="ytProgText"></div>
                    </div>
                </div>
            </div>
        </div>
    </section>

<script>
    var mfBase = '<%= ResolveUrl("~/lesen/migratefile.aspx") %>';
    var mfPlan = [], mfMissing = [], mfStopReq = false;

    function mfCall(method, data) {
        return fetch(mfBase + '/' + method, {
            method: 'POST', credentials: 'same-origin',
            headers: { 'Content-Type': 'application/json; charset=utf-8' },
            body: JSON.stringify(data || {})
        }).then(function (r) { if (!r.ok) throw new Error('HTTP ' + r.status); return r.json(); }).then(function (j) { return j.d; });
    }

    function mfLog(t) {
        var l = document.getElementById('mfLog');
        document.getElementById('mfLogWrap').style.display = '';
        l.textContent += t + '\n'; l.scrollTop = l.scrollHeight;
    }

    function mfFmt(b) {
        if (b > 1073741824) return (b / 1073741824).toFixed(2) + ' GB';
        if (b > 1048576) return (b / 1048576).toFixed(1) + ' MB';
        return Math.round(b / 1024) + ' KB';
    }

    function mfDoAnalyse() {
        var btn = document.getElementById('btnMfAnalyse'); btn.disabled = true;
        document.getElementById('mfLog').textContent = '';
        mfLog('Menganalisis...');
        mfCall('Analisis').then(function (r) {
            btn.disabled = false;
            if (!r.Ok) { mfLog('GAGAL: ' + r.Message); return; }
            mfPlan = r.Copy; mfMissing = r.Missing;
            document.getElementById('mfStats').style.display = '';
            document.getElementById('sTotal').textContent = r.Total;
            document.getElementById('sExists').textContent = r.Exists;
            document.getElementById('sCopy').textContent = r.ToCopy;
            document.getElementById('sMissing').textContent = r.NoSource;
            document.getElementById('sSize').textContent = mfFmt(r.Bytes);
            document.getElementById('mfSrc').textContent = 'Jadual: ' + r.Tables.join(', ') + (r.Ignored ? ' | Laluan diabaikan (di luar doc/Uploads atau tidak sah): ' + r.Ignored : '');
            document.getElementById('btnMfRun').disabled = mfPlan.length === 0;
            mfLog('Analisis selesai: ' + r.ToCopy + ' akan disalin, ' + r.Exists + ' sudah wujud, ' + r.NoSource + ' tiada di sumber.');
            mfMissing.slice(0, 200).forEach(function (m) { mfLog('TIADA DI SUMBER: ' + m); });
            if (mfMissing.length > 200) mfLog('... dan ' + (mfMissing.length - 200) + ' lagi.');
        }).catch(function (e) { btn.disabled = false; mfLog('RALAT: ' + e.message); });
    }

    function mfDoRun() {
        if (!mfPlan.length) return;
        if (!confirm('Salin ' + mfPlan.length + ' fail daripada sistem lama? Fail sedia ada tidak akan ditimpa.')) return;
        var total = mfPlan.length, done = 0, copied = 0, failed = 0, i = 0, BATCH = 50;
        mfStopReq = false;
        document.getElementById('btnMfRun').disabled = true; document.getElementById('btnMfAnalyse').disabled = true;
        document.getElementById('btnMfStop').style.display = '';
        document.getElementById('mfProg').style.display = '';

        function upd() {
            var p = Math.round(done * 100 / total);
            document.getElementById('mfProgBar').style.width = p + '%';
            document.getElementById('mfProgPct').textContent = p + '%';
            document.getElementById('mfProgText').textContent = done + ' / ' + total + ' diproses | ' + copied + ' disalin | ' + failed + ' gagal';
        }
        function end(msg) {
            document.getElementById('btnMfStop').style.display = 'none';
            document.getElementById('btnMfAnalyse').disabled = false;
            mfLog(msg + ' Tekan Analisis untuk semak semula.');
        }
        function next() {
            if (i >= total) { end('Selesai: ' + copied + ' disalin, ' + failed + ' gagal.'); return; }
            if (mfStopReq) { end('Dihenti oleh pengguna.'); return; }
            var batch = mfPlan.slice(i, i + BATCH);
            mfCall('SalinKelompok', { items: batch }).then(function (r) {
                if (!r.Ok) { end('GAGAL: ' + r.Message); return; }
                copied += r.Copied; failed += r.Failed; done += batch.length; i += BATCH;
                r.Errors.forEach(function (e) { mfLog('GAGAL: ' + e); });
                upd(); next();
            }).catch(function (e) { end('RALAT: ' + e.message); });
        }
        upd(); next();
    }

    // ---------- fail yatim di sistem baru
    var ytFiles = [], ytDb = '';

    function mfEsc(s) { return String(s).replace(/[&<>"]/g, function (c) { return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]; }); }

    function mfYtScan() {
        var btn = document.getElementById('btnYtScan'); btn.disabled = true;
        document.getElementById('btnYtDel').disabled = true;
        mfCall('AnalisisYatim').then(function (r) {
            btn.disabled = false;
            var sum = document.getElementById('ytSummary');
            if (!r.Ok) { sum.innerHTML = '<span class="text-danger">' + mfEsc(r.Message) + '</span>'; return; }
            ytFiles = r.Files; ytDb = r.Db;
            sum.innerHTML = 'DB sasaran <b>' + mfEsc(r.Db) + '</b> merujuk ' + r.Rujukan + ' fail. Fail di sistem baru: ' + r.Total +
                ' | <b>Fail yatim: ' + r.Files.length + '</b> (' + mfFmt(r.Bytes) + ')';
            var tb = document.getElementById('ytList'); tb.innerHTML = '';
            r.Info.forEach(function (x, idx) {
                var p = x.split('|');
                tb.insertAdjacentHTML('beforeend', '<tr><td><input type="checkbox" class="yt-chk" data-i="' + idx + '" onchange="mfYtSync()" /></td><td>' + mfEsc(p[0]) + '</td><td class="text-end">' + mfFmt(parseInt(p[1], 10)) + '</td><td>' + mfEsc(p[2]) + '</td></tr>');
            });
            document.getElementById('ytAll').checked = false;
            document.getElementById('ytListWrap').style.display = r.Files.length ? '' : 'none';
            mfYtSync();
        }).catch(function (e) { btn.disabled = false; document.getElementById('ytSummary').textContent = 'RALAT: ' + e.message; });
    }

    function mfYtAll(on) {
        document.querySelectorAll('.yt-chk').forEach(function (c) { c.checked = on; });
        mfYtSync();
    }

    function mfYtSelected() {
        var out = [];
        document.querySelectorAll('.yt-chk:checked').forEach(function (c) { out.push(ytFiles[parseInt(c.getAttribute('data-i'), 10)]); });
        return out;
    }

    function mfYtSync() {
        var all = document.querySelectorAll('.yt-chk'), n = mfYtSelected().length;
        var a = document.getElementById('ytAll');
        a.checked = all.length > 0 && n === all.length;
        a.indeterminate = n > 0 && n < all.length;
        var b = document.getElementById('btnYtDel');
        b.disabled = n === 0;
        b.innerHTML = '<i class="bi bi-trash3 me-1"></i>Padam dipilih' + (n ? ' (' + n + ')' : '');
    }

    function mfYtDelete() {
        var sel = mfYtSelected();
        if (!sel.length) return;
        var t = prompt('PEMADAMAN KEKAL ' + sel.length + ' fail di sistem baru (tidak boleh dipulihkan).\nFolder sistem lama tidak disentuh.\n\nTaip nama DB sasaran untuk mengesahkan: ' + ytDb);
        if (t === null) return;
        if (t.trim() !== ytDb) { alert('Nama DB tidak sepadan. Dibatalkan.'); return; }
        var total = sel.length, i = 0, del = 0, fail = 0, BATCH = 50;
        document.getElementById('btnYtDel').disabled = true; document.getElementById('btnYtScan').disabled = true;
        document.getElementById('ytProg').style.display = '';
        function upd() {
            document.getElementById('ytBar').style.width = Math.round(Math.min(i, total) * 100 / total) + '%';
            document.getElementById('ytProgText').textContent = Math.min(i, total) + ' / ' + total + ' diproses | ' + del + ' dipadam | ' + fail + ' gagal';
        }
        function end(msg) {
            document.getElementById('btnYtScan').disabled = false;
            document.getElementById('ytProgText').textContent += ' | ' + msg;
            mfLog('Fail yatim: ' + del + ' dipadam, ' + fail + ' gagal. ' + msg);
        }
        function next() {
            if (i >= total) { end('Selesai. Tekan Imbas untuk semak semula.'); return; }
            mfCall('PadamYatim', { items: sel.slice(i, i + BATCH) }).then(function (r) {
                if (!r.Ok) { end('GAGAL: ' + r.Message); return; }
                del += r.Copied; fail += r.Failed; i += BATCH;
                r.Errors.forEach(function (e) { mfLog('GAGAL PADAM: ' + e); });
                upd(); next();
            }).catch(function (e) { end('RALAT: ' + e.message); });
        }
        upd(); next();
    }
</script>
</asp:Content>
