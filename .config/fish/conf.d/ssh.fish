set -Ux SSH_ASKPASS "/usr/bin/ksshaskpass"
set -Ux SSH_ASKPASS_REQUIRE "prefer"

if test -z "$SSH_AUTH_SOCK"; or not test -e "$SSH_AUTH_SOCK"
    eval (ssh-agent -c) > /dev/null
end
