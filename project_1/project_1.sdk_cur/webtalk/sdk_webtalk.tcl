webtalk_init -webtalk_dir /home/jharing/git/2nd/chw2022g3/project_1/project_1.sdk/webtalk
webtalk_register_client -client project
webtalk_add_data -client project -key date_generated -value "2022-12-14 01:19:44" -context "software_version_and_target_device"
webtalk_add_data -client project -key product_version -value "SDK v2019.1" -context "software_version_and_target_device"
webtalk_add_data -client project -key build_version -value "2019.1" -context "software_version_and_target_device"
webtalk_add_data -client project -key os_platform -value "amd64" -context "software_version_and_target_device"
webtalk_add_data -client project -key registration_id -value "" -context "software_version_and_target_device"
webtalk_add_data -client project -key tool_flow -value "SDK" -context "software_version_and_target_device"
webtalk_add_data -client project -key beta -value "false" -context "software_version_and_target_device"
webtalk_add_data -client project -key route_design -value "NA" -context "software_version_and_target_device"
webtalk_add_data -client project -key target_family -value "NA" -context "software_version_and_target_device"
webtalk_add_data -client project -key target_device -value "NA" -context "software_version_and_target_device"
webtalk_add_data -client project -key target_package -value "NA" -context "software_version_and_target_device"
webtalk_add_data -client project -key target_speed -value "NA" -context "software_version_and_target_device"
webtalk_add_data -client project -key random_id -value "n71ok6tvk4jksdkjpqj380nhn9" -context "software_version_and_target_device"
webtalk_add_data -client project -key project_id -value "2019.1_2" -context "software_version_and_target_device"
webtalk_add_data -client project -key project_iteration -value "2" -context "software_version_and_target_device"
webtalk_add_data -client project -key os_name -value "Ubuntu" -context "user_environment"
webtalk_add_data -client project -key os_release -value "Ubuntu 22.04.1 LTS" -context "user_environment"
webtalk_add_data -client project -key cpu_name -value "AMD Ryzen 7 PRO 5850U with Radeon Graphics" -context "user_environment"
webtalk_add_data -client project -key cpu_speed -value "400.000 MHz" -context "user_environment"
webtalk_add_data -client project -key total_processors -value "1" -context "user_environment"
webtalk_add_data -client project -key system_ram -value "32.419 GB" -context "user_environment"
webtalk_register_client -client sdk
webtalk_add_data -client sdk -key uid -value "1670972221000" -context "sdk\\\\bsp/1670972221000"
webtalk_add_data -client sdk -key hwid -value "1670971319000" -context "sdk\\\\bsp/1670972221000"
webtalk_add_data -client sdk -key os -value "standalone" -context "sdk\\\\bsp/1670972221000"
webtalk_add_data -client sdk -key apptemplate -value "empty_application" -context "sdk\\\\bsp/1670972221000"
webtalk_add_data -client sdk -key RecordType -value "BSPCreation" -context "sdk\\\\bsp/1670972221000"
webtalk_add_data -client sdk -key uid -value "1670972222000" -context "sdk\\\\application/1670972222000"
webtalk_add_data -client sdk -key hwid -value "1670971319000" -context "sdk\\\\application/1670972222000"
webtalk_add_data -client sdk -key bspid -value "1670972221000" -context "sdk\\\\application/1670972222000"
webtalk_add_data -client sdk -key newbsp -value "true" -context "sdk\\\\application/1670972222000"
webtalk_add_data -client sdk -key os -value "standalone" -context "sdk\\\\application/1670972222000"
webtalk_add_data -client sdk -key apptemplate -value "empty_application" -context "sdk\\\\application/1670972222000"
webtalk_add_data -client sdk -key RecordType -value "APPCreation" -context "sdk\\\\application/1670972222000"
webtalk_add_data -client sdk -key LangUsed -value "CPP" -context "sdk\\\\application/1670972222000"
webtalk_add_data -client sdk -key Procused -value "ps7_cortexa9" -context "sdk\\\\application/1670972222000"
webtalk_add_data -client sdk -key projSize -value "406.515625" -context "sdk\\\\application/1670972222000"
webtalk_add_data -client sdk -key uid -value "NA" -context "sdk\\\\bsp/1670977184128"
webtalk_add_data -client sdk -key RecordType -value "ToolUsage" -context "sdk\\\\bsp/1670977184128"
webtalk_add_data -client sdk -key BootgenCount -value "0" -context "sdk\\\\bsp/1670977184128"
webtalk_add_data -client sdk -key DebugCount -value "30" -context "sdk\\\\bsp/1670977184128"
webtalk_add_data -client sdk -key PerfCount -value "0" -context "sdk\\\\bsp/1670977184128"
webtalk_add_data -client sdk -key FlashCount -value "0" -context "sdk\\\\bsp/1670977184128"
webtalk_add_data -client sdk -key CrossTriggCount -value "0" -context "sdk\\\\bsp/1670977184128"
webtalk_add_data -client sdk -key QemuDebugCount -value "0" -context "sdk\\\\bsp/1670977184128"
webtalk_transmit -clientid 1433501937 -regid "" -xml /home/jharing/git/2nd/chw2022g3/project_1/project_1.sdk/webtalk/usage_statistics_ext_sdk.xml -html /home/jharing/git/2nd/chw2022g3/project_1/project_1.sdk/webtalk/usage_statistics_ext_sdk.html -wdm /home/jharing/git/2nd/chw2022g3/project_1/project_1.sdk/webtalk/sdk_webtalk.wdm -intro "<H3>SDK Usage Report</H3><BR>"
webtalk_terminate
