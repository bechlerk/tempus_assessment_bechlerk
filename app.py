# Python script to test Docker container.

from palmerpenguins import load_penguins

def main():
    df = load_penguins()
    print(df.head())

if __name__ == "__main__":
    main()