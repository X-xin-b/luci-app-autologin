local m,s,e

m=Map("taskplan",translate("自动登录设置"),translate("<b>本功能用于设置开机自动登录宽带，支持中国电信、中国移动和中国联通等运营商。</b></br>") ..
translate("开机后将按照设定的延时时间（秒）自动执行登录操作。"))

s = m:section(TypedSection, 'global')
s.anonymous=true

e=s:option(TextValue, "customscript" ,translate("自定义脚本"))
e.description = translate("可以在此处添加自定义登录脚本")
e.rows = 5
e.default=" "

s=m:section(TypedSection,"ltime",translate("自动登录配置"))
s.addremove=true
s.anonymous=true
s.template = "cbi/tblsection"

e = s:option(Value, 'remarks', translate('备注'))
e.default = "宽带自动登录"

e=s:option(Flag,"enable",translate("启用"))
e.rmempty = false
e.default=0

e=s:option(Value, "username", translate("用户名"))
e.rmempty = true

e=s:option(Value, "password", translate("密码"))
e.password = true
e.rmempty = true

e=s:option(ListValue,"operator",translate("运营商"))
e:value("telecom", translate("中国电信"))
e:value("mobile", translate("中国移动"))
e:value("unicom", translate("中国联通"))
e.default="telecom"

e=s:option(Flag,"autologin",translate("开机自动登录"))
e.rmempty = false
e.default=1

e=s:option(Value,"delay",translate("延时登录(秒)"))
e.default=30

m.apply_on_parse = true
m.on_after_apply = function(self,map)
	luci.sys.exec("/etc/init.d/taskplan start")
end

return m