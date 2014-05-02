function bounding_boxes = sec_bb(sec, alignment)
%SEC_BB Returns an array of bounding boxes for a section after the specified alignment.
% Usage:
%   bounding_boxes = sec_bb(sec)
%   bounding_boxes = sec_bb(sec, alignment)
%
% Args:
%   sec is a structure generated by load_sec.
%   alignment is a string specifying the alignment to use. Defaults to the
%       last alignment added to sec.alignments, or a grid.
%
% Returns:
%   bounding_boxes an array of polygons of the bounding boxes of each tile.
%
% See also: draw_polys, ref_bb

alignments = fieldnames(sec.alignments);
use_grid = false;
if nargin < 2
    % Get last alignment
    alignment = alignments{end};
    
    % Use grid alignment if the last alignment is the initial (all identity).
    use_grid = strcmp(alignment, 'initial');
end

% Figure out which transforms to use
if use_grid
    grid_alignment = get_grid_alignment(sec);
    tforms = grid_alignment.tforms;
else
    alignment = validatestring(alignment, fieldnames(sec.alignments));
    tforms = sec.alignments.(alignment).tforms;
end

% Calculate bounding boxes
bounding_boxes = cell(sec.num_tiles, 1);
for i = 1:sec.num_tiles
    % Get an initial bounding box based on the tile size
    bb = sz2bb(sec.tile_sizes{i});
    
    % Apply alignment transform
    bb = tforms{i}.transformPointsForward(bb);
    
    % Save to array
    bounding_boxes{i} = bb;
end
end
