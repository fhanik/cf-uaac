#!/usr/bin/env ruby

#--
# Cloud Foundry 2012.02.03 Beta
# Copyright (c) [2009-2012] VMware, Inc. All Rights Reserved.
#
# This product is licensed to you under the Apache License, Version 2.0 (the "License").
# You may not use this product except in compliance with the License.
#
# This product includes a number of subcomponents with
# separate copyright notices and license terms. Your use of these
# subcomponents is subject to the terms and conditions of the
# subcomponent's license, as noted in the LICENSE file.
#++

$:.unshift File.expand_path File.join __FILE__, '..', '..', 'lib'
require 'cli'

client = ENV["UAA_CLIENT_ID"] || "admin"
secret = ENV["UAA_CLIENT_SECRET"] || "adminsecret"
abort("UAA_CLIENT_TARGET is not set") unless target = ENV["UAA_CLIENT_TARGET"]

[
  "target #{target}",
  "token client get #{client} -s #{secret}",
  "client update #{client} --authorities scim.read,scim.write,clients.read,clients.write,clients.secret,scim.password,uaa.admin,uaa.resource",
  "token client get #{client} -s #{secret}",
  "client -t add clapp -s clapp --scope scim.me,scim.read,openid,password.write --authorized_grant_types password,refresh_token,authorization_code --autoapprove true",
  "user add joe -p joe --email joe@email.com",
].each { |cmd| abort("'#{cmd}' failed") unless CF::UAA::Cli.run(cmd) }

