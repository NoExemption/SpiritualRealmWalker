using System.Reflection;
using System.Reflection.Emit;
using System.Reflection.Metadata;
using System.Reflection.Metadata.Ecma335;
using System.Reflection.PortableExecutable;

if (args.Length == 0) throw new ArgumentException("Provide the assembly DLL path as the first argument.");
using var stream = File.OpenRead(args[0]);
using var pe = new PEReader(stream);
var md = pe.GetMetadataReader();
var ops = typeof(OpCodes).GetFields(BindingFlags.Public | BindingFlags.Static).Select(f => (OpCode)f.GetValue(null)!).ToDictionary(o => unchecked((ushort)o.Value));
string tokenName(int token)
{
    var h = MetadataTokens.Handle(token);
    return h.Kind switch {
        HandleKind.UserString => "\"" + md.GetUserString((UserStringHandle)h) + "\"",
        HandleKind.MethodDefinition => md.GetString(md.GetMethodDefinition((MethodDefinitionHandle)h).Name),
        HandleKind.FieldDefinition => md.GetString(md.GetFieldDefinition((FieldDefinitionHandle)h).Name),
        HandleKind.MemberReference => md.GetString(md.GetMemberReference((MemberReferenceHandle)h).Name),
        HandleKind.TypeDefinition => md.GetString(md.GetTypeDefinition((TypeDefinitionHandle)h).Name),
        HandleKind.TypeReference => md.GetString(md.GetTypeReference((TypeReferenceHandle)h).Name),
        HandleKind.MethodSpecification => tokenName(MetadataTokens.GetToken(md.GetMethodSpecification((MethodSpecificationHandle)h).Method)),
        _ => h.Kind + " " + token.ToString("X8")
    };
}
foreach (var th in md.TypeDefinitions)
{
    var td = md.GetTypeDefinition(th);
    var tn = md.GetString(td.Name);
    var hasFontSubstitution = td.GetMethods().Any(h => md.GetString(md.GetMethodDefinition(h).Name) == "ApplyLocaleFontSubstitution");
    var hasTitleColors = td.GetFields().Any(h => md.GetString(md.GetFieldDefinition(h).Name) == "cardTitleOutlineCommon");
    if (!tn.Contains("CharacterSelect") && tn != "MegaRichTextLabel") continue;
    Console.WriteLine("TYPE " + md.GetString(td.Namespace) + "." + tn);
    foreach (var fh in td.GetFields()) { var f = md.GetFieldDefinition(fh); if (tn != "NCard") Console.WriteLine("FIELD " + md.GetString(f.Name)); }
    foreach (var mh in td.GetMethods())
    {
        var method = md.GetMethodDefinition(mh);
        var name = md.GetString(method.Name);
        Console.WriteLine("METHOD " + name);
        if (method.RelativeVirtualAddress == 0) continue;
        if (hasTitleColors && name != ".cctor") continue;
        if (tn == "NCard" && name is not ("Reload" or "UpdatePortrait" or "UpdateTypePlaque")) continue;
        if (tn == "CardModel" && name is not ("get_BannerMaterial" or "get_BannerMaterialPath")) continue;
        if (tn == "MegaLabel" && name is not ("RefreshFont" or "_Ready" or ".ctor" or "OnThemeChanged" or "_Notification")) continue;
        var il = pe.GetMethodBody(method.RelativeVirtualAddress).GetILBytes()!;
        int i = 0;
        while (i < il.Length) {
            var p = i; ushort code = il[i++]; if(code == 0xfe) code = (ushort)(0xfe00 | il[i++]); var op = ops[code];
            string value = ""; int n = 0;
            switch(op.OperandType) {
                case OperandType.InlineNone: break;
                case OperandType.ShortInlineI: value = ((sbyte)il[i]).ToString(); n=1; break;
                case OperandType.ShortInlineVar: value=il[i].ToString(); n=1; break;
                case OperandType.InlineVar: value=BitConverter.ToUInt16(il,i).ToString(); n=2;break;
                case OperandType.InlineI: value=BitConverter.ToInt32(il,i).ToString();n=4;break;
                case OperandType.InlineI8: value=BitConverter.ToInt64(il,i).ToString();n=8;break;
                case OperandType.ShortInlineR: value=BitConverter.ToSingle(il,i).ToString();n=4;break;
                case OperandType.InlineR: value=BitConverter.ToDouble(il,i).ToString();n=8;break;
                case OperandType.ShortInlineBrTarget: value="IL_"+(i+1+(sbyte)il[i]).ToString("X4");n=1;break;
                case OperandType.InlineBrTarget: value="IL_"+(i+4+BitConverter.ToInt32(il,i)).ToString("X4");n=4;break;
                case OperandType.InlineSwitch: var count=BitConverter.ToInt32(il,i);n=4+4*count;value="switch("+count+")";break;
                default: var token=BitConverter.ToInt32(il,i);value=tokenName(token)+" ["+token.ToString("X8")+"]";n=4;break;
            }
            i+=n;Console.WriteLine("IL_"+p.ToString("X4")+" "+op.Name+" "+value);
        }
    }
}
