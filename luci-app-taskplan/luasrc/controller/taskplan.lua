module("luci.controller.taskplan",package.seeall)
local fs=require"nixio.fs"
local http=require"luci.http"
function index()
	if not nixio.fs.access("/etc/config/taskplan") then
		return
	end
        entry({"admin", "login"}, firstchild(), "Login", 44).dependent = false
        local e = entry({"admin", "login", "taskplan"}, alias("admin", "login", "taskplan", "scheduledtask"), _("Task Plan"), 20)
	e.dependent = false
	e.acl_depends = { "luci-app-taskplan" }
        entry({"admin", "login", "taskplan", "startuptask"}, cbi("taskplan/startuptask"),  _("Startup task"), 20).leaf = true
        entry({"admin", "login", "taskplan", "log"}, form("taskplan/log"), _("Log"), 30).leaf = true
        entry({"admin","login","taskplan","dellog"},call("dellog"))
        entry({"admin","login","taskplan","getlog"},call("getlog"))
end

function getlog()
	logfile="/etc/taskplan/taskplan.log"
	if not fs.access(logfile) then
		http.write("")
		return
	end
	local f=io.open(logfile,"r")
	local a=f:read("*a") or ""
	f:close()
	a=string.gsub(a,"\n$","")
	http.prepare_content("text/plain; charset=utf-8")
	http.write(a)
end

function dellog()
	fs.writefile("/etc/taskplan/taskplan.log","")
	http.prepare_content("application/json")
	http.write('')
end
