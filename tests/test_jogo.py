import pytest
from jogo import Bola


def test_bola_move_direcao_certa():
    bola = Bola(x=100, y=100, vel_x=5, vel_y=3)
    bola.mover()
    assert bola.x == 105
    assert bola.y == 103


def test_bola_quica_nas_bordas_horizontais():
    bola = Bola(x=30, y=100, vel_x=-5, vel_y=0)  # bem na borda esquerda
    bola.mover()
    assert bola.vel_x == 5  # deve inverter direção


def test_bola_quica_nas_bordas_verticais():
    bola = Bola(x=100, y=30, vel_x=0, vel_y=-5)  # bem no topo
    bola.mover()
    assert bola.vel_y == 5  # deve inverter direção
