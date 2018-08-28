import std.digest.crc, std.digest.md, std.digest.sha;
import std.stdio;

// Digests a file and prints the result.
void digestFile(Digest hash, string filename)
{
    File file = File(filename);

    //As digests implement OutputRange, we could use std.algorithm.copy
    //Let's do it manually for now
    foreach (buffer; file.byChunk(4096 * 1024))
      hash.put(buffer);

    ubyte[] result = hash.finish();
    writefln("%s (%s) = %s", typeid(hash).toString(), filename, toHexString(result));
}

void main(string[] args)
{
    auto sha512 = new SHA512Digest();

    foreach (arg; args[1 .. $])
    {
      digestFile(sha512, arg);
    }
}
