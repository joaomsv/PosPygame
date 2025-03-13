"""Módulo principal do jogo Bola Maluca com pygame."""

import random
import sys
import pygame

# Cores RGB
BRANCO: tuple[int, int, int] = (255, 255, 255)
AZUL: tuple[int, int, int] = (30, 144, 255)

# Constantes da tela
LARGURA_TELA = 800
ALTURA_TELA = 600

# Propriedades da bola
RAIO_BOLA = 30
FPS = 60


class Bola:
    """Classe que representa a bola que se move e rebate nas bordas."""

    def __init__(self, x: int, y: int, vel_x: int, vel_y: int) -> None:
        """Inicializa a posição e a velocidade da bola."""
        self.x = x
        self.y = y
        self.vel_x = vel_x
        self.vel_y = vel_y

    def mover(self) -> None:
        """Atualiza a posição da bola e inverte a direção nas bordas."""
        self.x += self.vel_x
        self.y += self.vel_y

        if self.x - RAIO_BOLA <= 0 or self.x + RAIO_BOLA >= LARGURA_TELA:
            self.vel_x *= -1
        if self.y - RAIO_BOLA <= 0 or self.y + RAIO_BOLA >= ALTURA_TELA:
            self.vel_y *= -1

    def desenhar(self, tela: pygame.Surface) -> None:
        """Desenha a bola na tela do jogo."""
        pygame.draw.circle(tela, AZUL, (self.x, self.y), RAIO_BOLA)


def iniciar_jogo() -> None:
    """Função principal para inicializar e executar o jogo."""
    pygame.init()  # pylint: disable=no-member
    tela = pygame.display.set_mode((LARGURA_TELA, ALTURA_TELA))
    pygame.display.set_caption("🏀 Bola Maluca!")

    x_inicial = random.randint(RAIO_BOLA, LARGURA_TELA - RAIO_BOLA)
    y_inicial = random.randint(RAIO_BOLA, ALTURA_TELA - RAIO_BOLA)
    bola = Bola(
        x_inicial,
        y_inicial,
        random.choice([-4, 4]),
        random.choice([-4, 4])
    )

    relogio = pygame.time.Clock()
    rodando = True

    while rodando:
        for evento in pygame.event.get():
            if evento.type == pygame.QUIT:  # pylint: disable=no-member
                rodando = False

        bola.mover()

        tela.fill(BRANCO)
        bola.desenhar(tela)
        pygame.display.flip()
        relogio.tick(FPS)

    pygame.quit()  # pylint: disable=no-member
    sys.exit()


if __name__ == "__main__":
    iniciar_jogo()
