#!/bin/bash

cp ../tests/vm_common/boot-count.service /etc/systemd/system/.
cp ../tests/vm_common/boot_count.sh /usr/sbin/.
restorecon /etc/systemd/system/boot-count.service

systemctl daemon-reload
systemctl enable --now boot-count.service

cp ../tests/02_3vers_rpm_install/measure_reboot /usr/bin/.
chmod +x /usr/bin/measure_reboot
