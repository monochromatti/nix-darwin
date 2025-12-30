function start-vm() {
    local vm_name environment

    vm_name="$1"
    environment="$2"

    if [ -z "$vm_name" ] || [ -z "$environment" ]; then
        echo "Usage: start-vm <vm_name> <environment>"
        return 1
    fi

    if [ "$vm_name" = "vidar" ]; then
        if [ "$environment" = "prod" ]; then
            az vm start --subscription 584a2d66-5adc-45d5-b796-9d69d54154d6 --resource-group asgard --name vidar
        elif [ "$environment" = "dev" ]; then
            az vm start --subscription 5111c8c6-28f3-4b11-a07f-0aef3ed4721d --resource-group asgard --name vidar
        else
            echo "Unknown environment: $environment"
            return 1
        fi
    else
        echo "Unknown VM: $vm_name"
        return 1
    fi
}

function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}
