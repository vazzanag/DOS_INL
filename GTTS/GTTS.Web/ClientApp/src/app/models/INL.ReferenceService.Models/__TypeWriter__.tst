${
    using Typewriter.Extensions.Types;
    using System.Text.RegularExpressions;
    using System.Diagnostics;

    
    Template(Settings settings)
    {
        settings.OutputFilenameFactory = file => 
        {
            return ToKebabCase(file.Name).Replace(".cs", ".ts");
        };
    }

    string ToKebabCase(string value) {
      return Regex.Replace(value, "([a-z])([A-Z])", "$1-$2").ToLower();
    } 


    string ClassImports(Class c) => c.Properties
                                .Where(p => !p.Type.IsPrimitive || p.Type.IsEnum)
                                .Select(p => p.Type.Name)
                                .Where(name => name != c.Name)
                                .Where(name => name != "Stream")
                                .Append("" + ClassInterface(c))
                                .Where(name => !String.IsNullOrWhiteSpace(name))
                                .Select(name => $"import {{ {name.Replace("[]", "")} }} from './{ToKebabCase(name.Replace("[]", ""))}';")
                                .Distinct()
                                .Aggregate("", (all, import) => $"{all}{import}\r\n")
                                .TrimStart();

    string InterfaceImports(Interface i) => i.Properties
                                .Where(p => !p.Type.IsPrimitive || p.Type.IsEnum)
                                .Select(p => p.Type.Name)
                                .Where(name => name != i.Name)
                                .Where(name => name != "Stream")
                                .Select(name => $"import {{ {name.Replace("[]", "")} }} from './{ToKebabCase(name.Replace("[]", ""))}';")
                                .Distinct()
                                .Aggregate("", (all, import) => $"{all}{import}\r\n")
                                .TrimStart();

    string CustomClassProperties(Class c) => "\r\n" + c.Properties
                                        .Where(p => !(c.Name.EndsWith("_Param") && p.Name == "ModifiedByAppUserID"))
                                        .Select(p => $"{ClassPropertyDeclaration(p)}") 
                                        .Aggregate("", (all,prop) => $"{all}{prop}\r\n")
                                        .TrimEnd();

    string CustomInterfaceProperties(Interface i) => "\r\n" + i.Properties
                                        .Where(p => !(i.Name.EndsWith("_Param") && p.Name == "ModifiedByAppUserID"))
                                        .Select(p => $"{InterfacePropertyDeclaration(p)}") 
                                        .Aggregate("", (all,prop) => $"{all}{prop}\r\n")
                                        .TrimEnd();

    string ClassInterface(Class c) => c.Interfaces
                                .Where(i => i.Name == $"I{c.Name}")
                                .Select(i => i.Name)
                                .FirstOrDefault();

    string Implements(Class c) {
        string _interface = ClassInterface(c);
        if (!String.IsNullOrWhiteSpace(_interface)) return $"implements {_interface}";
        else return "";
    }

    string ClassPropertyDeclaration(Property p) {
        string name = p.Name + (p.Type.IsNullable || !p.Type.IsPrimitive ? "?" : "");
        string type = p.Type.Name;

        switch (p.Type.Name)
        {
            case "Boolean":
                type = "boolean";
                break;
            case "String":
            case "Char":
            case "Guid":
            case "TimeSpan":
                type = "string";
                break;
            case "Byte":
            case "SByte":
            case "Int16":
            case "Int32":
            case "Int64":
            case "UInt16":
            case "UInt32":
            case "UInt64":
            case "Single":
            case "Double":
            case "Decimal":
                type = "number";
                break;
            case "DateTime":
            case "DateTimeOffset":
                type = "Date";
                break;
            case "Void":
                type = "void";
                break;
            case "Object":
            case "dynamic":
                type = "any";
                break;
            case "Stream":
                type = "any";
                break;
        }
        
        if (name.EndsWith("?"))
            return $"\tpublic {name}: {type};";
        
        string value = "";

        switch (type)
        {
            case "boolean":
                value = "false";
                break;
            case "string":
                value = "\"\"";
                break;
            case "number":
                value = "0";
                break;
            case "Date":
                value = "new Date(0)";
                break;
            case "void":
                value = "void";
                break;
            case "any":
                value = "any";
                break;
            default: 
                value = "null";
                break;
        }


        return $"\tpublic {name}: {type} = {value};";
    }


    string InterfacePropertyDeclaration(Property p) {
        string name = p.Name + (p.Type.IsNullable || !p.Type.IsPrimitive ? "?" : "");
        string type = p.Type.Name;

        switch (p.Type.Name)
        {
            case "Boolean":
                type = "boolean";
                break;
            case "String":
            case "Char":
            case "Guid":
            case "TimeSpan":
                type = "string";
                break;
            case "Byte":
            case "SByte":
            case "Int16":
            case "Int32":
            case "Int64":
            case "UInt16":
            case "UInt32":
            case "UInt64":
            case "Single":
            case "Double":
            case "Decimal":
                type = "number";
                break;
            case "DateTime":
            case "DateTimeOffset":
                type = "Date";
                break;
            case "Void":
                type = "void";
                break;
            case "Object":
            case "dynamic":
                type = "any";
                break;
            case "Stream":
                type = "any";
                break;
        }

        return $"\t{name}: {type};";
    }


    string PropertyName(Property p) {
        return p.Name + (p.Type.IsNullable ? "?" : "");
    }

}
$Classes(INL.ReferenceService.Models.*)[
$ClassImports
export class $Name $Implements {
  $CustomClassProperties
  $BaseClass[$CustomClassProperties]
}]
$Interfaces(INL.ReferenceService.Models.*)[
$InterfaceImports
export interface $Name {
  $CustomInterfaceProperties

}]
$Enums(INL.ReferenceService.Models.*)[
export enum $Name { 
  $Values[
      $Name = $Value
  ][,]
}]
