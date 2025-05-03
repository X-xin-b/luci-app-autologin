local m,s,e

m=Map("taskplan",translate("自动登录设置"),translate("<b>本功能用于设置开机自动登录宽带，支持中国电信、中国移动和中国联通等运营商。</b></br>") ..
translate("开机后将按照设定的延时时间（秒）自动执行登录操作。"))

s = m:section(TypedSection, 'global')
s.anonymous=true


s=m:section(TypedSection,"ltime",translate("开机登录配置"))
s.anonymous=true
s.template = "cbi/tblsection"


e=s:option(Flag,"enable",translate("启用"))
e.rmempty = false
e.default=0

e=s:option(Value, "username", translate("用户名"))
e.rmempty = true

e=s:option(Value, "password", translate("密码"))
e.rmempty = true

e=s:option(ListValue,"operator",translate("运营商"))
e:value("telecom", translate("中国电信"))
e:value("mobile", translate("中国移动"))
e:value("unicom", translate("中国联通"))
e.default="telecom"


e=s:option(Value,"delay",translate("延时登录(秒)"))
e.default=30

-- 添加登录检测配置部分
s=m:section(NamedSection,"check","check",translate("登录检测配置"))
s.anonymous=true
s.addremove=false  -- 确保不能添加或删除此部分

e=s:option(Flag,"enable_check",translate("启用登录检测"))
e.rmempty = false
e.default=1
e.description = translate("启用后将检测登录是否成功")

e=s:option(Value,"check_interval",translate("检测间隔(分钟)"))
e.default=5
e.datatype = "uinteger"

e=s:option(Value,"check_target",translate("检测目标"))
e.default="www.baidu.com"
e.rmempty = false
e.description = translate("输入要ping的网址或IP地址，用于检测网络连接")

m.apply_on_parse = true
m.on_after_apply = function(self,map)
	luci.sys.exec("/etc/init.d/taskplan start")
end

return m