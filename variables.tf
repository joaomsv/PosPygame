variable tags {
    default = {
        Matrícula = "819229"
    }
}

locals {
    tags = {
        azureregion = "australiaeast"
        resourcegroup = "rg-${var.tags["Matrícula"]}"
        storageaccount = "stgaccount${var.tags["Matrícula"]}"
        datalake = "datalake-${var.tags["Matrícula"]}"
        vnet = "vnet-${var.tags["Matrícula"]}"
        subnet = "subnet-${var.tags["Matrícula"]}"
        securitygroup = "securitygroup-${var.tags["Matrícula"]}"
        instancetype = "Standard_E2as_v4"
        nomeusuariovm = "azureuser"
        vm_ip_allocated = "Static"
        ssh_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC4Rq5Iob9GNtBYfJRvM1qEBiCeL7iv9JMqjWetrW89vU7teLY4yknLVOKV+PBcO6iapT0dA3ZwPIkmLhJDcJAOLNK3ficLwU8kbOAzYVJ3iCny3rOLFskqSDBG2gKS69WJMEWUW/2o8M29IyFh+iIgh+37Y3e6ki3saju0cT2u/EZbTIfztqYw7cRR+cB4NmtLjStzHKpcDWDVG7uahChZy669G1fjioklGZpy6wRVcEEUXbo2vXP0AcaV+10JXP2mosJqERJXXgjp3MAg2be+9cjEOxmuswPw5glNbyj8+YU87GLv8unSWCbdAVTlgFBC+imlpbgCIeYImDHx9Vt1bNZZNDG0XeqPnDXRUfhFJ23/u1JBcziZll1YdMjl90WTiZXFftDQdgq4LsU3pYPOAo0j2vnraRQYaErufIgiOaHuHnRQy3C0Re1QicrFqq79dxpJPxH/2CHXKUo08rRSOWHjn5/8JrHvHm8aeXkYY78pdMDcERfZ1YV3Q+wp8i0= generated-by-azure"
        sub_id = "149db922-45ce-451e-9858-7a186af15039"
    }
}
