# main.py
# pip3 install numpy matplotlib scipy
# sudo apt install python3 python3-pip
import importlib

SCRIPTS = {
    "hw01_p01": "scripts.hw01_p01",
    "hw01_p02": "scripts.hw01_p02",
    "hw01_p03": "scripts.hw01_p03",
}

def main():
    print("Available problems:")
    for k in SCRIPTS:
        print(" ", k)

    choice = input("Run which problem? ").strip()
    if choice not in SCRIPTS:
        raise ValueError("Unknown problem")

    module = importlib.import_module(SCRIPTS[choice])
    module.main(save=True)

if __name__ == "__main__":
    main()
