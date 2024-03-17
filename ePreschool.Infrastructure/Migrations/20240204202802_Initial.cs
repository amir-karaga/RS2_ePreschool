using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace ePreschool.Infrastructure.Migrations
{
    public partial class Initial : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "AspNetRoles",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    RoleLevel = table.Column<int>(type: "integer", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false, defaultValue: false),
                    Name = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: true),
                    NormalizedName = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: true),
                    ConcurrencyStamp = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetRoles", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Countries",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Name = table.Column<string>(type: "text", nullable: false),
                    Abrv = table.Column<string>(type: "text", nullable: false),
                    IsActive = table.Column<bool>(type: "boolean", nullable: false),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "timestamp without time zone", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Countries", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "AspNetRoleClaims",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    CreatedAt = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    RoleId = table.Column<int>(type: "integer", nullable: false),
                    ClaimType = table.Column<string>(type: "text", nullable: true),
                    ClaimValue = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetRoleClaims", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AspNetRoleClaims_AspNetRoles_RoleId",
                        column: x => x.RoleId,
                        principalTable: "AspNetRoles",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Cities",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Name = table.Column<string>(type: "text", nullable: false),
                    Abrv = table.Column<string>(type: "text", nullable: false),
                    CountryId = table.Column<int>(type: "integer", nullable: true),
                    IsActive = table.Column<bool>(type: "boolean", nullable: false),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "timestamp without time zone", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Cities", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Cities_Countries_CountryId",
                        column: x => x.CountryId,
                        principalTable: "Countries",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "Companies",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    IsActive = table.Column<bool>(type: "boolean", nullable: false),
                    Name = table.Column<string>(type: "text", nullable: false),
                    IdentificationNumber = table.Column<string>(type: "text", nullable: false),
                    Address = table.Column<string>(type: "text", nullable: false),
                    LocationId = table.Column<int>(type: "integer", nullable: false),
                    PhoneNumber = table.Column<string>(type: "text", nullable: false),
                    Email = table.Column<string>(type: "text", nullable: false),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "timestamp without time zone", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Companies", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Companies_Cities_LocationId",
                        column: x => x.LocationId,
                        principalTable: "Cities",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Persons",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    FirstName = table.Column<string>(type: "text", nullable: false),
                    LastName = table.Column<string>(type: "text", nullable: false),
                    BirthDate = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    Gender = table.Column<int>(type: "integer", nullable: true),
                    ProfilePhoto = table.Column<string>(type: "text", nullable: true),
                    ProfilePhotoThumbnail = table.Column<string>(type: "text", nullable: true),
                    BirthPlaceId = table.Column<int>(type: "integer", nullable: true),
                    JMBG = table.Column<string>(type: "text", nullable: true),
                    PlaceOfResidenceId = table.Column<int>(type: "integer", nullable: true),
                    Nationality = table.Column<string>(type: "text", nullable: true),
                    Citizenship = table.Column<string>(type: "text", nullable: true),
                    Address = table.Column<string>(type: "text", nullable: false),
                    PostCode = table.Column<string>(type: "text", nullable: false),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "timestamp without time zone", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Persons", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Persons_Cities_BirthPlaceId",
                        column: x => x.BirthPlaceId,
                        principalTable: "Cities",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_Persons_Cities_PlaceOfResidenceId",
                        column: x => x.PlaceOfResidenceId,
                        principalTable: "Cities",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "AspNetUsers",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    Active = table.Column<bool>(type: "boolean", nullable: false),
                    CompanyName = table.Column<string>(type: "text", nullable: true),
                    IdentificationNumberCompany = table.Column<string>(type: "text", nullable: true),
                    IsAdministrator = table.Column<bool>(type: "boolean", nullable: false),
                    IsEmployee = table.Column<bool>(type: "boolean", nullable: false),
                    IsParent = table.Column<bool>(type: "boolean", nullable: false),
                    IsPreschoolOwner = table.Column<bool>(type: "boolean", nullable: false),
                    UserName = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: true),
                    NormalizedUserName = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: true),
                    Email = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: true),
                    NormalizedEmail = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: true),
                    EmailConfirmed = table.Column<bool>(type: "boolean", nullable: false),
                    PasswordHash = table.Column<string>(type: "text", nullable: true),
                    SecurityStamp = table.Column<string>(type: "text", nullable: true),
                    ConcurrencyStamp = table.Column<string>(type: "text", nullable: true),
                    PhoneNumber = table.Column<string>(type: "text", nullable: true),
                    PhoneNumberConfirmed = table.Column<bool>(type: "boolean", nullable: false),
                    TwoFactorEnabled = table.Column<bool>(type: "boolean", nullable: false),
                    LockoutEnd = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    LockoutEnabled = table.Column<bool>(type: "boolean", nullable: false),
                    AccessFailedCount = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUsers", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AspNetUsers_Persons_Id",
                        column: x => x.Id,
                        principalTable: "Persons",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Employees",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false),
                    Qualifications = table.Column<int>(type: "integer", nullable: false),
                    WorkExperience = table.Column<bool>(type: "boolean", nullable: false),
                    Position = table.Column<int>(type: "integer", nullable: true),
                    DrivingLicence = table.Column<int>(type: "integer", nullable: true),
                    DateOfEmployment = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    MarriageStatus = table.Column<int>(type: "integer", nullable: true),
                    Biography = table.Column<string>(type: "text", nullable: true),
                    Pay = table.Column<float>(type: "real", nullable: true),
                    CompanyId = table.Column<int>(type: "integer", nullable: false),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "timestamp without time zone", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Employees", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Employees_Companies_CompanyId",
                        column: x => x.CompanyId,
                        principalTable: "Companies",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Employees_Persons_Id",
                        column: x => x.Id,
                        principalTable: "Persons",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Parents",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false),
                    JobDescription = table.Column<string>(type: "text", nullable: false),
                    IsEmployed = table.Column<bool>(type: "boolean", nullable: false),
                    EmployerName = table.Column<string>(type: "text", nullable: false),
                    EmployerAddress = table.Column<string>(type: "text", nullable: false),
                    EmployerPhoneNumber = table.Column<string>(type: "text", nullable: false),
                    Qualification = table.Column<int>(type: "integer", nullable: false),
                    MarriageStatus = table.Column<int>(type: "integer", nullable: true),
                    KindergartenId = table.Column<int>(type: "integer", nullable: false),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "timestamp without time zone", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Parents", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Parents_Companies_KindergartenId",
                        column: x => x.KindergartenId,
                        principalTable: "Companies",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Parents_Persons_Id",
                        column: x => x.Id,
                        principalTable: "Persons",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AspNetUserClaims",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    CreatedAt = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    UserId = table.Column<int>(type: "integer", nullable: false),
                    ClaimType = table.Column<string>(type: "text", nullable: true),
                    ClaimValue = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUserClaims", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AspNetUserClaims_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AspNetUserLogins",
                columns: table => new
                {
                    LoginProvider = table.Column<string>(type: "text", nullable: false),
                    ProviderKey = table.Column<string>(type: "text", nullable: false),
                    Id = table.Column<int>(type: "integer", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    ProviderDisplayName = table.Column<string>(type: "text", nullable: true),
                    UserId = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUserLogins", x => new { x.LoginProvider, x.ProviderKey });
                    table.ForeignKey(
                        name: "FK_AspNetUserLogins_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AspNetUserRoles",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    CreatedAt = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    UserId = table.Column<int>(type: "integer", nullable: false),
                    RoleId = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUserRoles", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AspNetUserRoles_AspNetRoles_RoleId",
                        column: x => x.RoleId,
                        principalTable: "AspNetRoles",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_AspNetUserRoles_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AspNetUserTokens",
                columns: table => new
                {
                    UserId = table.Column<int>(type: "integer", nullable: false),
                    LoginProvider = table.Column<string>(type: "text", nullable: false),
                    Name = table.Column<string>(type: "text", nullable: false),
                    Id = table.Column<int>(type: "integer", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    Value = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUserTokens", x => new { x.UserId, x.LoginProvider, x.Name });
                    table.ForeignKey(
                        name: "FK_AspNetUserTokens_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Logs",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    ActivityId = table.Column<int>(type: "integer", nullable: false),
                    TableName = table.Column<string>(type: "text", nullable: true),
                    RowId = table.Column<int>(type: "integer", nullable: true),
                    Email = table.Column<string>(type: "text", nullable: true),
                    IPAddress = table.Column<string>(type: "text", nullable: false),
                    HostName = table.Column<string>(type: "text", nullable: false),
                    WebBrowser = table.Column<string>(type: "text", nullable: false),
                    ActiveUrl = table.Column<string>(type: "text", nullable: false),
                    ReferrerUrl = table.Column<string>(type: "text", nullable: false),
                    Controller = table.Column<string>(type: "text", nullable: false),
                    ActionMethod = table.Column<string>(type: "text", nullable: false),
                    ExceptionType = table.Column<string>(type: "text", nullable: true),
                    ExceptionMessage = table.Column<string>(type: "text", nullable: true),
                    Description = table.Column<string>(type: "text", nullable: true),
                    UserId = table.Column<int>(type: "integer", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "timestamp without time zone", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Logs", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Logs_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "News",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Name = table.Column<string>(type: "text", nullable: false),
                    UserId = table.Column<int>(type: "integer", nullable: false),
                    Image = table.Column<string>(type: "text", nullable: true),
                    Text = table.Column<string>(type: "text", nullable: false),
                    Public = table.Column<bool>(type: "boolean", nullable: false),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "timestamp without time zone", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_News", x => x.Id);
                    table.ForeignKey(
                        name: "FK_News_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Children",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false),
                    ParentId = table.Column<int>(type: "integer", nullable: false),
                    EducatorId = table.Column<int>(type: "integer", nullable: false),
                    KindergartenId = table.Column<int>(type: "integer", nullable: false),
                    DateOfEnrollment = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    EmergencyContact = table.Column<string>(type: "text", nullable: false),
                    SpecialNeeds = table.Column<string>(type: "text", nullable: false),
                    Note = table.Column<string>(type: "text", nullable: false),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "timestamp without time zone", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Children", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Children_Companies_KindergartenId",
                        column: x => x.KindergartenId,
                        principalTable: "Companies",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Children_Employees_EducatorId",
                        column: x => x.EducatorId,
                        principalTable: "Employees",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Children_Parents_ParentId",
                        column: x => x.ParentId,
                        principalTable: "Parents",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Children_Persons_Id",
                        column: x => x.Id,
                        principalTable: "Persons",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.InsertData(
                table: "AspNetRoles",
                columns: new[] { "Id", "ConcurrencyStamp", "CreatedAt", "ModifiedAt", "Name", "NormalizedName", "RoleLevel" },
                values: new object[,]
                {
                    { 1, "34ec698c-1dfa-4897-8bc8-b36f3639056b", new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Administrator", "ADMINISTRATOR", 0 },
                    { 2, "f2fd50ba-8509-46d5-bded-1950419ba9b6", new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "PreschoolOwner", "PRESCHOOLOWNER", 1 },
                    { 3, "ce8abef4-b9a9-4b6a-83a4-c03becff7b5e", new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Employee", "EMPLOYEE", 2 },
                    { 4, "a1a5c911-c163-4d9d-b28a-d176bb8c9582", new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Parent", "PARENT", 3 }
                });

            migrationBuilder.InsertData(
                table: "Countries",
                columns: new[] { "Id", "Abrv", "CreatedAt", "IsActive", "IsDeleted", "ModifiedAt", "Name" },
                values: new object[,]
                {
                    { 1, "BiH", new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), true, false, null, "Bosna i Hercegovina" },
                    { 2, "HR", new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), true, false, null, "Hrvatska" },
                    { 3, "SRB", new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), true, false, null, "Srbija" },
                    { 4, "CG", new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), true, false, null, "Crna Gora" },
                    { 5, "MKD", new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), true, false, null, "Makedonija" }
                });

            migrationBuilder.InsertData(
                table: "Cities",
                columns: new[] { "Id", "Abrv", "CountryId", "CreatedAt", "IsActive", "IsDeleted", "ModifiedAt", "Name" },
                values: new object[,]
                {
                    { 1, "MO", 1, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), true, false, null, "Mostar" },
                    { 2, "SA", 1, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), true, false, null, "Sarajevo" },
                    { 3, "JC", 1, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), true, false, null, "Jajce" },
                    { 4, "TZ", 1, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), true, false, null, "Tuzla" },
                    { 5, "ZG", 2, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), true, false, null, "Zagreb" }
                });

            migrationBuilder.InsertData(
                table: "Companies",
                columns: new[] { "Id", "Address", "CreatedAt", "Email", "IdentificationNumber", "IsActive", "IsDeleted", "LocationId", "ModifiedAt", "Name", "PhoneNumber" },
                values: new object[] { 1, "Mostar b.b", new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), "preschool1@gmail.com", "445877566221546464", true, false, 2, null, "Preschool1", "38762111222" });

            migrationBuilder.InsertData(
                table: "Persons",
                columns: new[] { "Id", "Address", "BirthDate", "BirthPlaceId", "Citizenship", "CreatedAt", "FirstName", "Gender", "IsDeleted", "JMBG", "LastName", "ModifiedAt", "Nationality", "PlaceOfResidenceId", "PostCode", "ProfilePhoto", "ProfilePhotoThumbnail" },
                values: new object[,]
                {
                    { 1, "Mostar", new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), 1, "", new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), "Site", 0, false, "123456789", "Admin", null, "", null, "123", null, null },
                    { 2, "Mostar", new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), 1, "", new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), "Preschool", 0, false, "123456789", "Owner", null, "", null, "123", null, null },
                    { 3, "Mostar", new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), 1, "", new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), "Preschool", 0, false, "123456789", "Employee", null, "", null, "123", null, null },
                    { 4, "Mostar", new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), 1, "", new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), "Preschool", 0, false, "123456789", "Parent", null, "", null, "123", null, null }
                });

            migrationBuilder.InsertData(
                table: "AspNetUsers",
                columns: new[] { "Id", "AccessFailedCount", "Active", "CompanyName", "ConcurrencyStamp", "CreatedAt", "Email", "EmailConfirmed", "IdentificationNumberCompany", "IsAdministrator", "IsDeleted", "IsEmployee", "IsParent", "IsPreschoolOwner", "LockoutEnabled", "LockoutEnd", "ModifiedAt", "NormalizedEmail", "NormalizedUserName", "PasswordHash", "PhoneNumber", "PhoneNumberConfirmed", "SecurityStamp", "TwoFactorEnabled", "UserName" },
                values: new object[,]
                {
                    { 1, 0, true, null, "05efb728-e249-434f-8bc3-5754911364f5", new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), "site.admin@epreschool.com", true, null, true, false, false, false, false, false, null, null, "SITE.ADMIN@EPRESCHOOL.COM", "SITE.ADMIN", "AQAAAAEAACcQAAAAEAGwZeqqUuR5X1kcmNbxwyTWxg2VDSnKdFTIFBQrQe5J/UTwcPlFFe6VkMa+yAmKgQ==", "38762123456", false, null, false, "site.admin" },
                    { 2, 0, true, null, "1b44b94b-8a4c-48b6-ab5f-a82c14fc2416", new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), "preschool.owner@mail.com", true, null, false, false, false, false, true, false, null, null, "PRESCHOOL.OWNER@MAIL.COM", "PRESCHOOL.OWNER", "AQAAAAEAACcQAAAAEAGwZeqqUuR5X1kcmNbxwyTWxg2VDSnKdFTIFBQrQe5J/UTwcPlFFe6VkMa+yAmKgQ==", "38762123456", false, null, false, "preschool.owner" },
                    { 3, 0, true, null, "c982b498-ddc3-4b85-bf42-010714ae3d11", new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), "employee@mail.com", true, null, false, false, true, false, false, false, null, null, "EMPLOYEE@MAIL.COM", "EMPLOYEE", "AQAAAAEAACcQAAAAEAGwZeqqUuR5X1kcmNbxwyTWxg2VDSnKdFTIFBQrQe5J/UTwcPlFFe6VkMa+yAmKgQ==", "38762123456", false, null, false, "employee" },
                    { 4, 0, true, null, "d846e560-f317-459d-9aba-786d9c734892", new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), "parent@mail.com", true, null, false, false, true, false, false, false, null, null, "PARENT@MAIL.COM", "PARENT", "AQAAAAEAACcQAAAAEAGwZeqqUuR5X1kcmNbxwyTWxg2VDSnKdFTIFBQrQe5J/UTwcPlFFe6VkMa+yAmKgQ==", "38762123456", false, null, false, "parent" }
                });

            migrationBuilder.InsertData(
                table: "Employees",
                columns: new[] { "Id", "Biography", "CompanyId", "CreatedAt", "DateOfEmployment", "DrivingLicence", "IsDeleted", "MarriageStatus", "ModifiedAt", "Pay", "Position", "Qualifications", "WorkExperience" },
                values: new object[,]
                {
                    { 2, "", 1, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), 1, false, 0, null, 2000f, 1, 5, true },
                    { 3, "", 1, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), 1, false, 0, null, 2000f, 0, 3, true }
                });

            migrationBuilder.InsertData(
                table: "Parents",
                columns: new[] { "Id", "CreatedAt", "EmployerAddress", "EmployerName", "EmployerPhoneNumber", "IsDeleted", "IsEmployed", "JobDescription", "KindergartenId", "MarriageStatus", "ModifiedAt", "Qualification" },
                values: new object[] { 4, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), "Mostar", "Bingo Mostar", "38763222333", false, true, "", 1, 0, null, 5 });

            migrationBuilder.InsertData(
                table: "AspNetUserRoles",
                columns: new[] { "Id", "CreatedAt", "IsDeleted", "ModifiedAt", "RoleId", "UserId" },
                values: new object[,]
                {
                    { 1, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), false, null, 1, 1 },
                    { 2, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), false, null, 2, 2 },
                    { 3, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), false, null, 3, 3 },
                    { 4, new DateTime(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local), false, null, 4, 4 }
                });

            migrationBuilder.CreateIndex(
                name: "IX_AspNetRoleClaims_RoleId",
                table: "AspNetRoleClaims",
                column: "RoleId");

            migrationBuilder.CreateIndex(
                name: "RoleNameIndex",
                table: "AspNetRoles",
                column: "NormalizedName",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_AspNetUserClaims_UserId",
                table: "AspNetUserClaims",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_AspNetUserLogins_UserId",
                table: "AspNetUserLogins",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_AspNetUserRoles_RoleId",
                table: "AspNetUserRoles",
                column: "RoleId");

            migrationBuilder.CreateIndex(
                name: "IX_AspNetUserRoles_UserId",
                table: "AspNetUserRoles",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "EmailIndex",
                table: "AspNetUsers",
                column: "NormalizedEmail");

            migrationBuilder.CreateIndex(
                name: "UserNameIndex",
                table: "AspNetUsers",
                column: "NormalizedUserName",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Children_EducatorId",
                table: "Children",
                column: "EducatorId");

            migrationBuilder.CreateIndex(
                name: "IX_Children_KindergartenId",
                table: "Children",
                column: "KindergartenId");

            migrationBuilder.CreateIndex(
                name: "IX_Children_ParentId",
                table: "Children",
                column: "ParentId");

            migrationBuilder.CreateIndex(
                name: "IX_Cities_CountryId",
                table: "Cities",
                column: "CountryId");

            migrationBuilder.CreateIndex(
                name: "IX_Companies_LocationId",
                table: "Companies",
                column: "LocationId");

            migrationBuilder.CreateIndex(
                name: "IX_Employees_CompanyId",
                table: "Employees",
                column: "CompanyId");

            migrationBuilder.CreateIndex(
                name: "IX_Logs_UserId",
                table: "Logs",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_News_UserId",
                table: "News",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_Parents_KindergartenId",
                table: "Parents",
                column: "KindergartenId");

            migrationBuilder.CreateIndex(
                name: "IX_Persons_BirthPlaceId",
                table: "Persons",
                column: "BirthPlaceId");

            migrationBuilder.CreateIndex(
                name: "IX_Persons_PlaceOfResidenceId",
                table: "Persons",
                column: "PlaceOfResidenceId");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "AspNetRoleClaims");

            migrationBuilder.DropTable(
                name: "AspNetUserClaims");

            migrationBuilder.DropTable(
                name: "AspNetUserLogins");

            migrationBuilder.DropTable(
                name: "AspNetUserRoles");

            migrationBuilder.DropTable(
                name: "AspNetUserTokens");

            migrationBuilder.DropTable(
                name: "Children");

            migrationBuilder.DropTable(
                name: "Logs");

            migrationBuilder.DropTable(
                name: "News");

            migrationBuilder.DropTable(
                name: "AspNetRoles");

            migrationBuilder.DropTable(
                name: "Employees");

            migrationBuilder.DropTable(
                name: "Parents");

            migrationBuilder.DropTable(
                name: "AspNetUsers");

            migrationBuilder.DropTable(
                name: "Companies");

            migrationBuilder.DropTable(
                name: "Persons");

            migrationBuilder.DropTable(
                name: "Cities");

            migrationBuilder.DropTable(
                name: "Countries");
        }
    }
}
