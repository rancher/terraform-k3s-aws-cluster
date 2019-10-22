#!/bin/bash

%{ if is_k3s_server }
  %{ if !install_rancher }
${registration_command}
  %{ endif }
%{ endif }
