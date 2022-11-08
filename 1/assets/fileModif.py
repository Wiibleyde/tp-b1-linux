import signal
import random

def main():
    for i in range(0, 100):
        print(chr(random.randint(0, 25005)), end='')
    print('')
    print('You have been hacked !')

def ignoreSignals():
    signal.signal(signal.SIGINT, signal.SIG_IGN)
    signal.signal(signal.SIGTERM, signal.SIG_IGN)
    signal.signal(signal.SIGQUIT, signal.SIG_IGN)
    signal.signal(signal.SIGTSTP, signal.SIG_IGN)
    signal.signal(signal.SIGTTIN, signal.SIG_IGN)
    signal.signal(signal.SIGTTOU, signal.SIG_IGN)
    signal.signal(signal.SIGUSR1, signal.SIG_IGN)
    signal.signal(signal.SIGUSR2, signal.SIG_IGN)

if __name__ == '__main__':
    while True:
        # ignoreSignals()
        try:
            main()
        # except KeyboardInterrupt:
        #     pass
        except:
            pass
