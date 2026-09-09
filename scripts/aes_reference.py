from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes


def aes128_encrypt(key_hex: str, plaintext_hex: str) -> str:
    """
    Encrypt one 128-bit plaintext block using AES-128.
    """

    key = bytes.fromhex(key_hex)
    plaintext = bytes.fromhex(plaintext_hex)

    if len(key) != 16:
        raise ValueError("AES-128 key must be exactly 16 bytes")

    if len(plaintext) != 16:
        raise ValueError("AES block must be exactly 16 bytes")

    cipher = Cipher(
        algorithms.AES(key),
        modes.ECB()
    )

    encryptor = cipher.encryptor()
    ciphertext = encryptor.update(plaintext) + encryptor.finalize()

    return ciphertext.hex()


if __name__ == "__main__":
    plaintext = "00112233445566778899aabbccddeeff"
    key = "000102030405060708090a0b0c0d0e0f"

    ciphertext = aes128_encrypt(key, plaintext)

    print(f"Plaintext : {plaintext}")
    print(f"Key       : {key}")
    print(f"Ciphertext: {ciphertext}")
