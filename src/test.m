% Add class definitions to path.
addpath('./classes');

%% Creating models

% Initializing a QSMBCylindrical can be done in various ways. Constructing
% a QSM requires the following cylinder-level information:
% 
% Cylinder start point      [N x 3]
% Cylinder axis direction   [N x 3]
% Cylinder length           [N x 1]
% Cylinder radius           [N x 1]
% Cylinder parent index     [N x 1]
% Cylinder branch index     [N x 1]
% Cylinder added status     [N x 1]     (Optional)
%
% All other data is derived from these values. Derived values include
% cylinder extensions, branch order, cylinder index inside branch,
% flag for last cylinders in each branch, and branch level properties
% such as branch angles, volumes, lengths and heights.
%
% Required data can be passed into the class constructor in the following
% formats.

%% Format 1: Separate cylinder property matrices.

% Cylinder start point      [N x 3]
Sta = [ ...
     0  0  0; ...
     0  0  1; ...
     1  0  2; ...
     0  0  1; ...
     0  1  2; ...
     0  0  1; ...
     0 -1  2; ...
     0  0  1; ...
    -1  0  2; ...
];

% Cylinder axis direction   [N x 3]
Axe = [ ...
     0.000  0.000  1.000; ...
     0.707  0.000  0.707; ...
     1.000  0.000  0.000; ...
     0.000  0.707  0.707; ...
     0.000  1.000  0.000; ...
     0.000 -0.707  0.707; ...
     0.000 -1.000  0.000; ...
    -0.707  0.000  0.707; ...
    -1.000  0.000  0.000; ...
];

% Cylinder length           [N x 1]
Len = [ ...
    1.000; ...
    1.414; ...
    1.000; ...
    1.414; ...
    1.000; ...
    1.414; ...
    1.000; ...
    1.414; ...
    1.000; ...
];

% Cylinder radius           [N x 1]
Rad = [ ...
    0.3; ...
    0.2; ...
    0.1; ...
    0.2; ...
    0.1; ...
    0.2; ...
    0.1; ...
    0.2; ...
    0.1; ...
];

% Cylinder parent index     [N x 1]
Par = [ ...
    0; ...
    1; ...
    2; ...
    1; ...
    4; ...
    1; ...
    6; ...
    1; ...
    8; ...
];

% Cylinder branch index     [N x 1]
BI = [ ...
    1; ...
    1; ...
    1; ...
    2; ...
    2; ...
    3; ...
    3; ...
    4; ...
    4; ...
];

% Cylinder added status     [N x 1] or empty.
Added = [];

% Triangulated stem is optional and should be given as a struct with the
% fields vertices, faces and cylinders.
Tris = struct();

% Vertex coordinates of triangle stem.
Tris.vertices = [ ...
    -0.6 -0.6 0;
     0.7 -0.7 0;
     0.6  0.6 0;
    -0.7  0.7 0;
    -0.3 -0.3 1;
     0.2 -0.2 1;
     0.3  0.3 1;
    -0.2  0.2 1;
];

% Vertex indices of each face.
Tris.faces = [ ...
    1 6 5;
    1 2 6;
    2 7 6;
    2 3 7;
    3 8 7;
    3 4 8;
    4 5 8;
    4 1 5;
    5 6 7;
    5 7 8;
    1 3 2;
    1 4 3;
];

% Indices of cylinders that are represented with the triangulated stem.
% Usually a vector of indices but in the example we only have the first
% cylinder.
Tris.cylinders = 1;

QSM = QSMBCylindrical(Sta,Axe,Len,Rad,Par,BI,Added,Tris);


%% Format 2: Struct with cylinder, branch and tree-level data fields.

ModelStruct.cylinder.start = Sta;
ModelStruct.cylinder.axis = Axe;
ModelStruct.cylinder.length = Len;
ModelStruct.cylinder.radius = Rad;
ModelStruct.cylinder.parent = Par;
ModelStruct.cylinder.branch = BI;
ModelStruct.triangulation.vert = Tris.vertices;
ModelStruct.triangulation.facet = Tris.faces;
ModelStruct.triangulation.cylid = max(Tris.cylinders);

QSM2 = QSMBCylindrical(ModelStruct);

%% Format 3: Cell-array with cylinder, branch and tree-level data.

CylData = [
% Rad Len      Sta                  Axe CPar CExt BI BO IIB Add
0.3 1.000  0  0  0  0.000  0.000  1.000    0    1  1  0   1   0;
0.2 1.414  0  0  1  0.707  0.000  0.707    1    2  1  0   2   0;
0.1 1.000  1  0  2  1.000  0.000  0.000    2    0  1  1   3   0;
0.2 1.414  0  0  1  0.000  0.707  0.707    1    4  2  1   1   0;
0.1 1.000  0  1  2  0.000  1.000  0.000    4    0  2  1   2   0;
0.2 1.414  0  0  1  0.000 -0.707  0.707    1    6  3  1   1   0;
0.1 1.000  0 -1  2  0.000 -1.000  0.000    6    0  3  1   2   0;
0.2 1.414  0  0  1 -0.707  0.000  0.707    1    8  4  1   1   0;
0.1 1.000 -1  0  2 -1.000  0.000  0.000    8    0  4  1   2   0;
];

BranchData = [
% BOrd   BPar   BVol   BLen   BAng   BHei
     0      0 0.4918 3.4140 0.0000 1.3333;
     1      1 0.2091 2.4140 0.7854 1.7499;
     1      1 0.2091 2.4140 0.7854 1.7499;
     1      1 0.2091 2.4140 0.7854 1.7499;
];

TreeData = [
 1.1192; % Total volume of the tree
 0.4918; % Volume of the trunk
 0.6273; % Total volume of all the branches
 2.0000; % Total height of the tree
 3.4140; % Length of the trunk
10.6560; % Total length of all the branches
 4.0000; % Total number of branches
 1.0000; % Maximum branch order
11.5058; % Total area of cylinders
 0.0000; % DBH = Diameter at breast height, from the QSM
 0.0000; % DBH from cylinder fitted to right place
 0.0000; % DBH from triangulation
];

% Cell array format of tree model data.
ModelCell = {CylData, BranchData, TreeData};

% Initialize QSM object.
QSM3 = QSMBCylindrical(ModelCell);

%% Format 4: Simple example model from string descriptor.

%This type of initialization is only designed for demonstration purposes.

QSM4 = QSMBCylindrical('example');

%%

% Inspecting a QSMBCylindrical object gives us the following output.
disp(QSM);

% QSMBCylindrical with properties:
%
%     cylinder_start_point: [9×3 single]
%            cylinder_axis: [9×3 single]
%          cylinder_length: [9×1 single]
%          cylinder_radius: [9×1 single]
%          cylinder_parent: [9×1 uint16]
%       cylinder_extension: [9×1 uint16]
%    cylinder_branch_index: [9×1 uint16]
%    cylinder_branch_order: [9×1 uint8]
% cylinder_index_in_branch: [9×1 uint16]
%       cylinder_end_point: [9×3 single]
%       cylinder_mid_point: [9×3 single]
%         cylinder_is_last: [9×1 logical]
%           cylinder_added: [9×1 logical]
%             branch_count: 0
%             branch_order: [4×1 uint8]
%            branch_parent: [4×1 uint16]
%            branch_volume: [4×1 single]
%            branch_length: [4×1 single]
%             branch_angle: [4×1 single]
%            branch_height: [4×1 single]
%        has_triangle_stem: 0
%            stem_vertices: []
%               stem_faces: []
%       triangle_cylinders: []
%                    debug: 0
%             color_matrix: [10×3 double]
%              block_count: 9
%              tree_limits: [2×3 double]
%    fun_twig_distribution: @default_twig_param_dist
%       twig_length_limits: [0.0200 0.0500]

% The number of geometric primitives, i.e., blocks/cylinders is
% stored in the BLOCK_COUNT property.
NCylinder = QSM.block_count;

% Branch count.
NBranch = QSM.branch_count;

% Bounding box of the model is stored in the TREE_LIMITS property
% as a [2 x 3] element matrix, where the first row is the minimum
% point and the second the maximum.
BoundingBox = QSM.tree_limits;

%% Plotting models

subplot(1,3,1);

% A model can be visualized with the PLOT_MODEL method.
% By default the model will be colored according to vertex height,
% and each cylinder will have 5 faces.
% 
% Plotting can be customized with various optional input arguments.
% See QSMBCylindrical.PLOT_MODEL for details.
%
% The function returns a PATCH object that can be used to manipulate
% the visualization afterwards.
hQSM = QSM.plot_model();
set(hQSM,'EdgeColor',[0 0 0]);

subplot(1,3,2);

% Plot model with more faces on each cylinder, close cylinder top and 
% bottom and set color source as branch order. Additionally set EdgeColor
% as black to see the faces more clearly.
%
% As the color source, i.e., order is a discrete quantity the color values
% from the constant object property COLOR_MATRIX are used to visualize the
% different branch orders. In turn the current COLORMAP is used for
% continuous color sources, like the default 'VertexHeight'.
QSM.plot_model( ...
    'Closed', ...
    'FaceCount',[10 20], ...
    'ColorSource','Order', ...
    'PlotOptions',{'EdgeColor',[0 0 0]} ...
);

subplot(1,3,3);

% Same as above but plot using the triangulated stem and use vertex height
% as color source.
QSM.plot_model( ...
    'TriangleStem', ...
    'Closed', ...
    'FaceCount',[10 20], ...
    'ColorSource','VertexHeight', ...
    'PlotOptions',{'EdgeColor',[0 0 0]} ...
);

%% Exporting models

% A QSMBCylindrical object can be exported in various formats for
% visualization and further computations. The EXPORT method handles
% exporting tree data in to a file.

% Export as a Polygon file format file (.PLY).
% Set face count to vary linearly between 5 and 10 based on cylinder
% radius and close cylinder top and bottom with a triangle fan. Also export
% color with the values computed from vertex height.
QSM.export( ...
    'PLY', ...
    'export_test.ply', ...
    'FaceCount',[5 10], ...
    'Closed', ...
    'ColorSource', ...
    'VertexHeight' ...
);

% Export as a Wavefront OBJ file (.OBJ).
% Set face count to vary linearly between 5 and 10 based on cylinder
% radius and close cylinder top and bottom with a triangle fan. 
% Export triangulated stem triangles and exclude respective stem
% cylinders.
% OBJ files do not support color values directly.
QSM.export( ...
    'OBJ', ...
    'export_test.obj', ...
    'TriangleStem', ...
    'FaceCount',[5 10], ...
    'Closed' ...
);

% Export as a text file compatible with the qsm-blender-addons.
% The format is cylinder based rather than vertex-face-based.
% Color sources are supported and branch order is used as the color source.
QSM.export( ...
    'blender', ...
    'export_test.txt', ...
    'ColorSource', ...
    'Order' ...
);

% There is also a text file format that contains all cylinder, branch and
% tree-level data. However, the final format of the text file is still
% being finalized and it may change.
QSM.export( ...
    'TXT', ...
    'export_test_all.txt' ...
);

% Converting cylinders into vertices and faces inside Matlab can be done
% with the COMPUTE_GEOMETRY method. The only required argument is the 
% face count by optional arguments are also available. See 
% QSMBCylindrical.COMPUTE_GEOMETRY for details.
[Vertices,Faces] = QSM.compute_geometry( ...
    [5,10], ... % Envelope face count between 5 and 10.
    [], ...     % Optional filtering, i.e., only convert selected cyls.
    true, ...   % Use quads instead of triangles on envelope.
    true ...    % Use triangle fans to close cylinder top and bottom.
);

%% Compress and uncompress

% Many of the values stored in a QSM are derived from a few key values.
% Thus, in order to save space when storing models, it is possible to
% compress the QSMBCylindrical objects by clearing out all the derived
% values.
%
% Note that performing computations on compressed models should not be done
% as the results may be unexpected or lead to errors.

% Compression status can be checked with the read-only property COMPRESSED.
% The value is TRUE when a model is compressed and FALSE otherwise.
disp(QSM.compressed);

% A model can be compressed with the COMPRESS method.
QSMc = QSM.compress();

% Checking the object properties of QSMc shows that most of them are indeed
% empty, thus saving space. Also note that the COMPRESSED property is now
% TRUE.
disp(QSMc);

% QSMBCylindrical with properties:
%
%       cylinder_start_point: [9×3 single]
%              cylinder_axis: [9×3 single]
%            cylinder_length: [9×1 single]
%            cylinder_radius: [9×1 single]
%            cylinder_parent: [9×1 uint16]
%         cylinder_extension: []
%      cylinder_branch_index: [9×1 uint16]
%      cylinder_branch_order: []
%   cylinder_index_in_branch: []
%         cylinder_end_point: [0×3 double]
%         cylinder_mid_point: [0×3 double]
%           cylinder_is_last: []
%             cylinder_added: [9×1 logical]
%               branch_count: 0
%               branch_order: []
%              branch_parent: []
%              branch_volume: []
%              branch_length: []
%               branch_angle: []
%              branch_height: []
%          has_triangle_stem: 0
%              stem_vertices: []
%                 stem_faces: []
%         triangle_cylinders: []
%                      debug: 0
%               color_matrix: [10×3 double]
%                block_count: 9
%                tree_limits: []
%      fun_twig_distribution: @default_twig_param_dist
%         twig_length_limits: [0.0200 0.0500]
%                 compressed: 1

% Uncompressing a model can be done with the UNCOMPRESS method.
QSM = QSMc.uncompress();

% Inspection shows that derived property values have been restored.
disp(QSM);

% QSMBCylindrical with properties:
%
%       cylinder_start_point: [9×3 single]
%              cylinder_axis: [9×3 single]
%            cylinder_length: [9×1 single]
%            cylinder_radius: [9×1 single]
%            cylinder_parent: [9×1 uint16]
%         cylinder_extension: [9×1 uint16]
%      cylinder_branch_index: [9×1 uint16]
%      cylinder_branch_order: [9×1 uint8]
%   cylinder_index_in_branch: [9×1 uint16]
%         cylinder_end_point: [9×3 single]
%         cylinder_mid_point: [9×3 single]
%           cylinder_is_last: [9×1 logical]
%             cylinder_added: [9×1 logical]
%               branch_count: 0
%               branch_order: [4×1 uint8]
%              branch_parent: [4×1 uint16]
%              branch_volume: [4×1 single]
%              branch_length: [4×1 single]
%               branch_angle: [4×1 single]
%              branch_height: [4×1 single]
%          has_triangle_stem: 0
%              stem_vertices: []
%                 stem_faces: []
%         triangle_cylinders: []
%                      debug: 0
%               color_matrix: [10×3 double]
%                block_count: 9
%                tree_limits: [2×3 single]
%      fun_twig_distribution: @default_twig_param_dist
%         twig_length_limits: [0.0200 0.0500]
%                 compressed: 0

%% Model transformations.

% This example generates a specified number of copies of the example
% QSM and translates, rotates and scales the copies on the circumference
% of a circle of given radius. The result is visualized by plotting all
% models in a single figure.

% Number of transformed models.
NModel = 10;

% Radius of circle.
rad = 15;

% Generate angles of trees.
ang = linspace(0, -2*pi, NModel + 1);
ang = ang(1:end-1);

% Generate scales of trees.
sca = linspace(1, 3, NModel);

% Convert polar coordinates to Cartesian for translation.
[x, y, z] = pol2cart(...
    ang, ...
    repmat(rad, 1, NModel), ...
    zeros(1, NModel) ...
);

% Collect components to single matrix.
tra = [x(:), y(:), z(:)];

% Convert angles to degrees.
ang = rad2deg(ang);

% Base model that is transformed.
QSM = QSMBCylindrical('example');

% Open figure.
f = figure(1);

% Ensure it is empty. (Patch objects, do not respect hold status.)
clf(f);

% Generate transformed models in loop.
for iModel = 1:NModel

    % Rotate by negative angle.
    QSMi = QSM.rotate(-ang(iModel));

    % Translate to circle circumference.
    QSMi = QSMi.translate(tra(iModel,:));

    % Scale by given factor.
    QSMi = QSMi.scale(sca(iModel));

    % Plot model and use coloring that highlights orientation.
    QSMi.plot_model('ColorSource','CylinderBranchIndex');
    hold on;

end

hold off;