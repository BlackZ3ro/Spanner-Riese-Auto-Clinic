using System.Security.Cryptography;
using System.Text;
using System.Xml.Linq;
using Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel;
using Microsoft.AspNetCore.DataProtection.Repositories;

namespace Spanner.Web.Auth;

// On Vercel the app runs as containers that are started and stopped on demand,
// sometimes several at once. By default each one invents its own Data
// Protection key, so a login form or login cookie made by one container is
// rejected by the next (HTTP 400 on "Log in", or a surprise logout). This
// repository gives every container the same key, derived from one secret
// setting (DataProtection:Secret / DataProtection__Secret in Vercel).
// Nothing is written anywhere: the key only ever exists in memory.
public sealed class FixedKeyRepository(string secret) : IXmlRepository
{
    public IReadOnlyCollection<XElement> GetAllElements()
    {
        var masterKey = SHA512.HashData(Encoding.UTF8.GetBytes("Spanner.Web/data-protection-key/" + secret));
        var keyId = new Guid(SHA256.HashData(Encoding.UTF8.GetBytes("Spanner.Web/data-protection-id/" + secret))[..16]);

        var key = new XElement("key",
            new XAttribute("id", keyId),
            new XAttribute("version", 1),
            new XElement("creationDate", "2026-01-01T00:00:00Z"),
            new XElement("activationDate", "2026-01-01T00:00:00Z"),
            new XElement("expirationDate", "2099-12-31T00:00:00Z"),
            new XElement("descriptor",
                new XAttribute("deserializerType", typeof(AuthenticatedEncryptorDescriptorDeserializer).AssemblyQualifiedName!),
                new XElement("descriptor",
                    new XElement("encryption", new XAttribute("algorithm", "AES_256_CBC")),
                    new XElement("validation", new XAttribute("algorithm", "HMACSHA256")),
                    new XElement("masterKey", new XElement("value", Convert.ToBase64String(masterKey))))));

        return [key];
    }

    // Keys come from configuration only; nothing to store.
    public void StoreElement(XElement element, string friendlyName)
    {
    }
}
