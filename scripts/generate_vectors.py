from scripts.aes_reference import aes128_encrypt


TEST_VECTORS = [
    {
        "name": "NIST_FIPS_197",
        "key": "000102030405060708090a0b0c0d0e0f",
        "plaintext": "00112233445566778899aabbccddeeff",
    },
    {
        "name": "ZERO_KEY_ZERO_PT",
        "key": "00000000000000000000000000000000",
        "plaintext": "00000000000000000000000000000000",
    },
    {
        "name": "ZERO_KEY_NONZERO_PT",
        "key": "00000000000000000000000000000000",
        "plaintext": "00000000000000000000000000000001",
    },
]


def main():
    with open("tb/aes_vectors.txt", "w") as f:
        for vector in TEST_VECTORS:
            ciphertext = aes128_encrypt(
                vector["key"],
                vector["plaintext"],
            )

            f.write(
                f'{vector["name"]} '
                f'{vector["key"]} '
                f'{vector["plaintext"]} '
                f'{ciphertext}\n'
            )

    print("Generated tb/aes_vectors.txt")


if __name__ == "__main__":
    main()
